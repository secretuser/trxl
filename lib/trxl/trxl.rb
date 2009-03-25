require "rubygems"
require "treetop"

# load treetop grammar
# this is done independent of RAILS_ROOT to allow easy
# speccing outside of rails context
# TODO once stable, replace this with a simple require
Treetop.load "#{File.dirname(__FILE__)}/trxl_grammar.treetop"

class Hash
  def to_s
    inspect
  end
end

class Array
  def to_s
    inspect
  end
end


# reopen treetop generated module
module Trxl
  
  class TrxlException < Exception; end
  class InternalError < TrxlException; end
  class FatalParseError < TrxlException; end
  class DivisionByZeroError < FatalParseError; end
  class MissingFormulaException < TrxlException; end
  class MissingVariableException < TrxlException; end
  class InvalidOperationException < TrxlException; end
  class InvalidArgumentException < TrxlException; end
  class WrongNumberOfArgumentsException < TrxlException; end
  
  class MissingLibraryException < TrxlException; end
  class NotImplementedException < TrxlException; end
  
  class ExitScopeNotAllowedException < TrxlException; end
  
  class Assignment < Treetop::Runtime::SyntaxNode; end
  class Variable < Treetop::Runtime::SyntaxNode; end
  
  
  
  class Environment
    
    # called when parsing starts
    def initialize(local_env = {})
      @stack = [ local_env ]
    end
    
    def enter_scope
      push #peek.dup
    end
    
    def exit_scope
      pop
    end
    
    def local
      peek
    end
    
    
    def depth
      @stack.size
    end
    
    def merge(other_env)
      self.class.new(local.merge(other_env))
    end
    
    def merge!(other_env)
      local.merge!(other_env); self
    end
    
    
    def [](variable)
      var = variable.to_sym
      @stack.each do |env|
        if env.has_key?(var)
          return env[var]
        end
      end
      nil
    end

    # FIXME find out why map definition doesn't work
    def []=(variable, value)
      var = variable.to_sym
      # search all scopes
      @stack.each do |env|
        if env.has_key?(var)
          return env[var] = value 
        end
      end
      # not found, assign it in local scope
      local[var] = value
    end
    
    def to_s
      @stack.inject([]) do |stack, env|
        stack << env.inspect
      end.join(',')
    end
    
    def empty?
      @stack.size == 1 ? peek.empty? : @stack.all? { |h| h.empty? }
    end
    
    def has_key?(key)
      @stack.any? { |env| env.has_key?(key.to_sym) }
    end
    
    def select(&block)
      @stack.inject([]) do |memo, env|
        memo << env.select(&block)
      end[0]
    end
    
    def add_library(name)
      (@libraries || []) << name.to_sym
    end
    
    def library_included?(name)
      @libraries ? @libraries.include?(name.to_sym) : false
    end
    
    def libraries
      @libraries.dup # don't allow modifications outside
    end
    
    protected
    
    # called when a new scope is entered
    def push(local_env = {})
      @stack.insert(0, local_env)
    end
    
    # called when a scope is left
    def pop
      if depth > 1
        @stack.shift
      else
        raise Trxl::ExitScopeNotAllowedException, "cannot pop toplevel environment"
      end
    end
    
    # always the local environment
    def peek
      @stack[0]
    end
    
  end
  
  class Function < Treetop::Runtime::SyntaxNode
    
    class Closure
      attr_reader :env, :function

      def initialize(function, env = Environment.new)
        @function = function
        @env = env
      end

      def apply(args)
        env.enter_scope
        return_value = function.body.eval(function.formal_parameter_list.bind(args, env))
        env.exit_scope
        return_value
      end

      def to_s(other_env = Environment.new)
        function.text_value #"fun#{function.formal_parameter_list.to_s(env)} {#{function.body.to_s(other_env.merge(env.local))}}"
      end
    end

    def eval(env = Environment.new)
      Closure.new(self, env)
    end

    def to_s(env = Environment.new)
      text_value #eval(env).to_s(env)
    end
  end
  
  class BinaryOperation < Treetop::Runtime::SyntaxNode
    
    def eval(env = Environment.new)
      apply(operand_1.eval(env), operand_2.eval(env))
    end
    
    def apply(a, b)
      operator.apply(a, b)
    end
    
    def to_s(env = Environment.new)
      "#{operand_1.to_s(env)} #{operator.text_value} #{operand_2.to_s(env)}"
    end
    
  end
  
  module BinaryOperatorSupport

    def lhs_nil_allowed?
      raise InternalError, "Implement BinaryOperaterSupport#lhs_nil_allowed?"
    end
    
    def rhs_nil_allowed?
      raise InternalError, "Implement BinaryOperaterSupport#rhs_nil_allowed?"
    end
    
    def nils_allowed?
      lhs_nil_allowed? && rhs_nil_allowed?
    end
    
    def apply(a, b)
      if a.nil?
        if b.nil?
          if nils_allowed?
            perform_apply(a, b)
          else
            raise InvalidArgumentException, "Both operands MUST NOT be NULL"
          end
        else
          if lhs_nil_allowed?
            perform_apply(a, b)
          else
            raise InvalidArgumentException, "LHS operand MUST NOT be NULL"
          end
        end
      else
        if b.nil?
          if rhs_nil_allowed?
            perform_apply(a, b)
          else
            raise InvalidArgumentException, "RHS operand MUST NOT be NULL"
          end
        else
          perform_apply(a, b)
        end
      end 
    end
    
    def perform_apply(a, b)
      if a.respond_to?(ruby_operator)
        a.send(ruby_operator, b)
      else
        _a = a ? (a.is_a?(String) ? "'#{a}'" : a) : false
        _b = b ? (b.is_a?(String) ? "'#{b}'" : b) : false
        eval "#{_a} #{ruby_operator} #{_b}"
      end
    end
    
    def ruby_operator
      text_value
    end
    
  end
  
  class NilRejectingOperator < Treetop::Runtime::SyntaxNode
    
    include BinaryOperatorSupport
    
    def lhs_nil_allowed?
      false
    end
    
    def rhs_nil_allowed?
      false
    end
    
  end
  
  class NilAcceptingOperator < Treetop::Runtime::SyntaxNode
    
    include BinaryOperatorSupport
    
    def lhs_nil_allowed?
      true
    end
    
    def rhs_nil_allowed?
      true
    end
    
  end
  
  
  class OffsetAccessExpression < Treetop::Runtime::SyntaxNode
    
    def left_associative_apply(ruby_object, offsets)
      offsets.inject(ruby_object) { |obj, offset| obj = obj[offset] }
    end
      
  end
  
  class RequireDirective < Treetop::Runtime::SyntaxNode
    
    def eval(env = Environment.new)
      library = ((l = load_library(env))[-1..-1]) == ';' ? "#{l} ENV" : "#{l}; ENV"
      unless env.library_included?(identifier(env))
        env.merge!(Calculator.new.eval(library, env).local)
        env.add_library(identifier(env))
      end
      env
    end
    
    def identifier(env = Environment.new)
      @identifier ||= string_literal.eval(env)
    end
    
    # override this in subclasses    
    def load_library(env = Environment.new)
      path = identifier(env).split('/')
      if path[0] == ('stdlib')
        if optimize_stdlib_access?
          if path.size == 2
            const = path[1].upcase
            if Trxl::StdLib.constants.include?(const)
              Calculator.stdlib(const)
            else
              raise MissingLibraryException, "Failed to load '#{identifier}'"
            end
          else
            Calculator.stdlib
          end
        else
          raise NotImplementedException, "Only optimized access is supported"
        end
      else
        raise NotImplementedException, "Only require 'stdlib' is supported"
      end
    end
    
    def optimize_stdlib_access?
      true
    end
      
  end
  
  
  # This module exists only for performance reason.
  # Loading the stdlib directly from a ruby object,
  # should be much faster than loading it from a file.
  
  module StdLib
    
    FOREACH_IN = <<-PROGRAM
      foreach_in = fun(enumerable, body) {
        _foreach_in_(enumerable, body, 0);
      };
      _foreach_in_ = fun(enumerable, body, index) {
        if(index < SIZE(enumerable) - 1)
          body(enumerable[index]);
          _foreach_in_(enumerable, body, index + 1)
        else
          body(enumerable[index])
        end
      };
    PROGRAM

    INJECT = <<-PROGRAM
      inject = fun(memo, enumerable, body) {
        _inject_(memo, enumerable, body, 0);
      };
      _inject_ = fun(memo, enumerable, body, index) {
        if(index < SIZE(enumerable) - 1)
          _inject_(body(memo, enumerable[index]), enumerable, body, index + 1)
        else
          body(memo, enumerable[index])
        end
      };
    PROGRAM

    MAP = <<-PROGRAM
      require 'stdlib/inject';
      map = fun(enumerable, body) {
        b = body; # WORK AROUND a bug in Trxl::Environment
        inject([], enumerable, fun(memo, e) { memo << b(e); });
      };
    PROGRAM

    SELECT = <<-PROGRAM
      require 'stdlib/inject';
      select = fun(enumerable, body) {
        b = body; # WORK AROUND a bug in Trxl::Environment
        inject([], enumerable, fun(selected, value) { 
          if(b(value))
            selected << value
          else
            selected
          end 
        });
      };
    PROGRAM
    
    REJECT = <<-REJECT
      require 'stdlib/inject';
      reject = fun(enumerable, filter) {
        f = filter; # WORKAROUND for a bug in Trxl::Environment
        inject([], enumerable, fun(rejected, value) {
          if(f(value)) 
            rejected
          else
            rejected << value
          end 
        })
      };
    REJECT
    
    IN_GROUPS_OF = <<-IN_GROUPS_OF
      require 'stdlib/foreach_in';
      require 'stdlib/inject';
      in_groups_of = fun(size_of_group, enumerable, group_function) {
        count = 0; groups = []; cur_group = []; 
        foreach_in(enumerable, fun(element) {
          if(count < size_of_group)
            cur_group << element;
            count = count + 1
          end;
          if(count == size_of_group)
            groups << cur_group;
            cur_group = [];
            count = 0
          end
        });
        group_count = 0;
        inject([], groups, fun(memo, group) {
          group_count = group_count + 1;
          memo << group_function(group, group_count);
          memo
        });
      };
    IN_GROUPS_OF
    
    SUM_OF_TYPE = <<-SUM_OF_TYPE
      sum_of_type = fun(type, all_types, all_values) {
        SUM(VALUES_OF_TYPE(type, all_types, all_values));
      };
    SUM_OF_TYPE

    AVG_SUM_OF_TYPE = <<-AVG_SUM_OF_TYPE
      avg_sum_of_type = fun(type, all_types, all_values) {
        AVG_SUM(VALUES_OF_TYPE(type, all_types, all_values));
      };
    AVG_SUM_OF_TYPE

    AVG_RANGE_SUM_OF_TYPE = <<-AVG_RANGE_SUM_OF_TYPE
      require 'stdlib/inject';
      require 'stdlib/avg_sum_of_type';
      avg_range_sum_of_type = fun(type, all_types, variable_range) {
        inject(0, variable_range, fun(sum, variable) { 
          sum + avg_sum_of_type(type, all_types, ENV[variable]) 
        });
      };
    AVG_RANGE_SUM_OF_TYPE
    
    TOTAL_RANGE_SUM_OF_TYPE = <<-TOTAL_RANGE_SUM_OF_TYPE
      require 'stdlib/inject';
      require 'stdlib/sum_of_type';
      total_range_sum_of_type = fun(type, all_types, variable_range) {
        inject(0, variable_range, fun(sum, variable) { 
          sum + sum_of_type(type, all_types, ENV[variable]) 
        });
      };
    TOTAL_RANGE_SUM_OF_TYPE

    YEAR_FROM_DATE = <<-YEAR_FROM_DATE
      year_from_date = fun(date) {
        date = SPLIT(date, '/');
        TO_INT(date[1]);
      };
    YEAR_FROM_DATE

    MONTH_FROM_DATE = <<-MONTH_FROM_DATE
      month_from_date = fun(date) {
        date = SPLIT(date, '/');
        TO_INT(date[0]);
      };
    MONTH_FROM_DATE

    DATES = <<-DATES
      require 'stdlib/month_from_date';
      require 'stdlib/year_from_date';
    DATES
    
    RATIO = <<-RATIO
      require 'stdlib/foreach_in';
      ratio = fun(enumerable, true_condition, base_condition) {
        base = 0;
        positives = 0;
        foreach_in(enumerable, fun(val) {
          if(ENV[val] != base_condition)
            base = base + 1
          end;
          if(ENV[val] == true_condition)
            positives = positives + 1
          end;
        });
        if(base > 0)
          ROUND((ROUND(positives, 1) / base) * 100, 2)
        else
          NULL
        end
      };
    RATIO

    LIFE_EXPECTANCY = <<-LIFE_EXPECTANCY
      life_expectancy = fun(vehicle_type) {
        case vehicle_type
          when "Kleinbus (Van etc.)"             then  7.0
          when "Pritschenwagen"                  then  7.0
          when "PKW"                             then  7.0
          when "LKW"                             then  9.0
          when "Omnibus"                         then  9.0
          when "Radlader (z.B. Volvo L90D)"      then 12.0
          when "Traktor groß (z.B. Steyr 8075)"  then 12.0
          when "Traktor klein (KUBOTA etc.)"     then 10.0
          when "Unimog"                          then 12.0
          when "Zugmaschine (z.B. Holder C9.88)" then 12.0
          when "Kehrmaschine"                    then 10.0
          when "Schneefräse"                     then 10.0
          when "Streuwagen"                      then 10.0
          else 0
        end
      };
    LIFE_EXPECTANCY

    TECH_OP_HOURS = <<-TECH_OP_HOURS 
      technical_operating_hours = fun(vehicle_type) {
        case vehicle_type
          when "Kleinbus (Van etc.)"             then  428.57
          when "Pritschenwagen"                  then  342.86
          when "PKW"                             then  428.57
          when "LKW"                             then  444.44
          when "Omnibus"                         then  400.0
          when "Radlader (z.B. Volvo L90D)"      then 1250.0
          when "Traktor groß (z.B. Steyr 8075)"  then  833.33
          when "Traktor klein (KUBOTA etc.)"     then  900.0
          when "Unimog"                          then 1000.0
          when "Zugmaschine (z.B. Holder C9.88)" then 1667.67
          when "Kehrmaschine"                    then  200.0
          when "Schneefräse"                     then  350.0
          when "Streuwagen"                      then  120.0
          else 0
        end
      };
    TECH_OP_HOURS

    AMORTIZATION = <<-AMORTIZATION
      require 'stdlib/dates';
      require 'stdlib/life_expectancy';
      amortization = fun(vehicle_type, acquisition_date, acquisition_cost) {
        useful_life_expectancy = life_expectancy(vehicle_type);
        acquisition_month = month_from_date(acquisition_date);
        acquisition_year = year_from_date(acquisition_date);
        if(useful_life_expectancy > 0)
          if(acquisition_month > 6)
            if((acquisition_year + useful_life_expectancy) >= TIME_LINE_ROOT)
              ROUND((acquisition_cost / useful_life_expectancy) / 2, 2)
            else
              0
            end
          else
            if((acquisition_year + useful_life_expectancy) > TIME_LINE_ROOT)
              ROUND(acquisition_cost / useful_life_expectancy, 2)
            else
              0
            end      
          end
        else
          0
        end
      };
    AMORTIZATION

    TOTAL_AMORTIZATION = <<-TOTAL_AMORTIZATION
      require 'stdlib/inject';
      require 'stdlib/amortization';
      total_amortization = fun(vehicle_types, acquisition_years, acquisition_costs) {
        inject(0, TO_ARRAY(vehicle_types), fun(sum, vehicle_type) {
          acquisition_year = acquisition_years[vehicle_type[0]];
          acquisition_cost = acquisition_costs[vehicle_type[0]];
          sum + amortization(vehicle_type[1], acquisition_year, acquisition_cost);
        })
      };
    TOTAL_AMORTIZATION
    
    
    AVG_UTILIZATION_RATIO = <<-AVG_UTILIZATION_RATIO
      require 'stdlib/tech_op_hours';
      require 'stdlib/avg_sum_of_type';
      avg_utilization_ratio = fun(vehicle_type, vehicle_types, op_hours) {
        if(SIZE(MATCHING_IDS(vehicle_type, vehicle_types)) > 0)
          tech_op_hours = technical_operating_hours(vehicle_type);
          act_op_hours = avg_sum_of_type(vehicle_type, vehicle_types, op_hours);
          if(tech_op_hours > 0)
            (100 / tech_op_hours) * act_op_hours
          else
            NULL
          end
        else
          NULL
        end
      };
    AVG_UTILIZATION_RATIO
    
    TOTAL_AVG_UTILIZATION_RATIO = <<-TOTAL_AVG_UTILIZATION_RATIO
      require 'stdlib/inject';
      require 'stdlib/tech_op_hours';
      total_avg_utilization_ratio = fun(vehicle_types, op_hours) {
        nr_of_vehicles = SIZE(vehicle_types);
        total_ratio = inject(0, TO_ARRAY(vehicle_types), fun(total, type) {
          tech_op_hours = technical_operating_hours(type[1]);
          act_op_hours = op_hours[type[0]];
          total + ((100 / tech_op_hours) * act_op_hours)
        });
        if(nr_of_vehicles > 0)
          total_ratio / nr_of_vehicles
        else
          NULL
        end
      };
    TOTAL_AVG_UTILIZATION_RATIO
    
    AVG_WORKING_COSTS = <<-AVG_WORKING_COSTS
      require 'stdlib/avg_sum_of_type';
      avg_working_costs = fun(building_type) {
        if(SIZE(MATCHING_IDS(building_type, b)) > 0)
          costs = avg_sum_of_type(building_type, b, c);
          area = avg_sum_of_type(building_type, b, d);
          if(area != 0)
            ROUND(costs / area, 2)
          else
            NULL
          end
        else
          NULL
        end
      };
    AVG_WORKING_COSTS
    
    AVG_HEATING_COSTS = <<-AVG_HEATING_COSTS
      require 'stdlib/avg_range_sum_of_type';
      avg_heating_costs = fun(building_type) {
        if(SIZE(MATCHING_IDS(building_type, b)) > 0)
          costs = avg_range_sum_of_type(building_type, b, 'c'..'e');
          area = avg_sum_of_type(building_type, b, f);
          if(area != 0)
            ROUND(costs / area, 2)
          else
            NULL
          end
        else
          NULL
        end
      };
    AVG_HEATING_COSTS
    
    AVG_MAINTENANCE_COSTS = <<-AVG_MAINTENANCE_COSTS
      require 'stdlib/avg_sum_of_type';
      avg_maintenance_costs = fun(building_type) {
        if(SIZE(MATCHING_IDS(building_type, b)) > 0)
          costs = avg_sum_of_type(building_type, b, c);
          area = avg_sum_of_type(building_type, b, d);
          if(area != 0)
            ROUND(costs / area, 2)
          else
            NULL
          end
        else
          NULL
        end
      };
    AVG_MAINTENANCE_COSTS
    
    CLEANING_EXPENSES = <<-CLEANING_EXPENSES
      require 'stdlib/sum_of_type';
      require 'stdlib/avg_sum_of_type';
      require 'stdlib/in_groups_of';

      special_cleaning_expense = fun(category) {
        case category
          when 1 then 100
          when 2 then  50
          when 3 then 800
          when 4 then 400
          when 5 then 200
          when 6 then  10
          else 0
        end
      };

      basic_cleaning_expense = fun(area, complete_cleanings) {
        if(area && complete_cleanings) 
          area / 50 * complete_cleanings
        else
          0
        end
      };

      theoretical_cleaning_expense = fun(cleaning_category, area, cleanings_per_month) {
        special_expense = special_cleaning_expense(cleaning_category);
        if((area && cleanings_per_month) && (complete_cleanings && special_expense != 0))
          area / special_expense * cleanings_per_month * 52
        else
          0
        end
      };

      cleaning_expenses_for_category = fun(cleaning_category, area, cleanings_per_month, complete_cleanings) {
        theoretical_cleaning_expense(cleaning_category, area, cleanings_per_month) + 
        basic_cleaning_expense(area, complete_cleanings);
      };
      
      cleaning_expenses = fun(building_type, variable_range) {
        result = in_groups_of(3, variable_range, fun(group, group_nr) {
          area     = sum_of_type(building_type, b, ENV[group[0]]);
          per_week = sum_of_type(building_type, b, ENV[group[1]]);
          per_year = sum_of_type(building_type, b, ENV[group[2]]);
          cleaning_expenses_for_category(group_nr, area, per_week, per_year);
        });
        SUM(result);
      };    
    CLEANING_EXPENSES
    
    CLEANING_EFFICIENCY = <<-CLEANING_EFFICIENCY
      require 'stdlib/cleaning_expenses';
      cleaning_efficiency = fun(building_type) {
        if(SIZE(MATCHING_IDS(building_type, b)) > 0)
          expenses = cleaning_expenses(building_type, 'c'..'t');
          if(expenses != 0)
            ROUND(avg_sum_of_type(building_type, b, u) / expenses * 100, 2)
          else
            NULL
          end
        else
          NULL
        end
      };
    CLEANING_EFFICIENCY
    
  end
  
  
  class Calculator
    
    extend StdLib # optimized for performance
    
    class << self
      
      def stdlib(function = nil)
        if function
          Kernel.eval("Trxl::StdLib::#{function.to_s.upcase}").strip
        else
          Trxl::StdLib.constants.inject('') do |lib, const|
            lib << Kernel.eval("Trxl::StdLib::#{const}")
          end.strip
        end
      end
      
    end

    def initialize
      @parser = TrxlParser.new
    end

    # may raise
    # overwrite treetop to provide more precise exceptions
    def parse(code, verbose = true)
      if ast = @parser.parse(code)
        ast
      else
        failure_idx = @parser.failure_index
        
        # extract code snippet where parse error happened
        start = ((idx = failure_idx - 12) < 0 ? 0 : idx)
        stop  = ((idx = failure_idx + 12) > code.size ? code.size : idx)
        local_code = code.slice(start..stop).to_s.gsub(/\n|\r/, "")
        
        msg =  "Parse Error at index #{failure_idx} (showing excerpt):\n"
        msg << "... #{local_code} ...\n"
        
        # mark the exact offset where the parse error happened
        offset = (start == 0) ? failure_idx + 4 : 16
        offset.times { msg << ' '}; msg << "^\n"
        
        if verbose
          # show the originial trxl program
          msg << "Original Code:\n#{code}\n\n"
          # add detailed treetop parser error messages
          msg << @parser.failure_reason
        end
        raise(Trxl::FatalParseError, msg)
      end
    end

    # may raise
    # eval an expression in calculations.treetop grammar
    # eval an already parsed Treetop::Runtime::SyntaxNode
    def eval(expression, env = Environment.new, verbose = true, interpreter_mode = false)
      if expression.is_a?(Treetop::Runtime::SyntaxNode)
        interpreter_mode ? [ expression.eval(env), env ] : expression.eval(env)
      else
        ast = parse(expression, verbose)
        interpreter_mode ? [ ast.eval(env), env ] : ast.eval(env)
      end
    end

  end
  
  class Interpreter
    
    attr_accessor :parser, :program, :env
    
    def initialize
      @parser = Calculator.new
      @program = []
      @env = env
    end
    
    def stash(loc)
      @program << loc
    end
    
    def eval(env = [])
      @parser.eval(@program.join(' '), env)
    end
    
  end
  
end


