module Trxl
  include Treetop::Runtime

  def root
    @root || :program
  end

  module Program0
    def space
      elements[0]
    end

    def statement_list
      elements[1]
    end

    def space
      elements[2]
    end
  end

  module Program1
    def eval(env = Environment.new)
      statement_list.eval(env)
    end
  end

  module Program2
    def space
      elements[0]
    end

  end

  module Program3
    def eval(env = Environment.new)
      nil
    end
  end

  def _nt_program
    start_index = index
    if node_cache[:program].has_key?(index)
      cached = node_cache[:program][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_space
    s1 << r2
    if r2
      r3 = _nt_statement_list
      s1 << r3
      if r3
        r4 = _nt_space
        s1 << r4
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(Program0)
      r1.extend(Program1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i5, s5 = index, []
      r6 = _nt_space
      s5 << r6
      if r6
        s7, i7 = [], index
        loop do
          r8 = _nt_statement_separator
          if r8
            s7 << r8
          else
            break
          end
        end
        r7 = SyntaxNode.new(input, i7...index, s7)
        s5 << r7
      end
      if s5.last
        r5 = (SyntaxNode).new(input, i5...index, s5)
        r5.extend(Program2)
        r5.extend(Program3)
      else
        self.index = i5
        r5 = nil
      end
      if r5
        r0 = r5
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:program][start_index] = r0

    return r0
  end

  module RequireDirective0
    def require_keyword
      elements[0]
    end

    def space
      elements[1]
    end

    def string_literal
      elements[2]
    end
  end

  def _nt_require_directive
    start_index = index
    if node_cache[:require_directive].has_key?(index)
      cached = node_cache[:require_directive][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_require_keyword
    s0 << r1
    if r1
      r2 = _nt_space
      s0 << r2
      if r2
        r3 = _nt_string_literal
        s0 << r3
      end
    end
    if s0.last
      r0 = (RequireDirective).new(input, i0...index, s0)
      r0.extend(RequireDirective0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:require_directive][start_index] = r0

    return r0
  end

  module StatementList0
    def statement_separator
      elements[0]
    end

    def expression
      elements[1]
    end
  end

  module StatementList1
    def expression
      elements[0]
    end

    def more_expressions
      elements[1]
    end

  end

  module StatementList2
    def eval(env = Environment.new)
      last_eval = nil
      #env.enter_scope
      expressions.each do |e|
        last_eval = e.eval(env)
      end
      #env.exit_scope
      last_eval
    end

    def expressions
      [ expression ] + more_expressions.elements.map { |e| e.expression }
    end

    def to_s(env = Environment.new)
      expressions.map { |e| e.to_s(env) }.join(' ')
    end
  end

  def _nt_statement_list
    start_index = index
    if node_cache[:statement_list].has_key?(index)
      cached = node_cache[:statement_list][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_expression
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        i3, s3 = index, []
        r4 = _nt_statement_separator
        s3 << r4
        if r4
          r5 = _nt_expression
          s3 << r5
        end
        if s3.last
          r3 = (SyntaxNode).new(input, i3...index, s3)
          r3.extend(StatementList0)
        else
          self.index = i3
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = SyntaxNode.new(input, i2...index, s2)
      s0 << r2
      if r2
        s6, i6 = [], index
        loop do
          r7 = _nt_statement_separator
          if r7
            s6 << r7
          else
            break
          end
        end
        r6 = SyntaxNode.new(input, i6...index, s6)
        s0 << r6
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(StatementList1)
      r0.extend(StatementList2)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:statement_list][start_index] = r0

    return r0
  end

  module StatementSeparator0
    def space
      elements[0]
    end

    def space
      elements[2]
    end
  end

  module StatementSeparator1
    def to_s(env = Environment.new)
      text_value
    end
  end

  def _nt_statement_separator
    start_index = index
    if node_cache[:statement_separator].has_key?(index)
      cached = node_cache[:statement_separator][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_space
    s0 << r1
    if r1
      if input.index(';', index) == index
        r2 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure(';')
        r2 = nil
      end
      s0 << r2
      if r2
        r3 = _nt_space
        s0 << r3
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(StatementSeparator0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:statement_separator][start_index] = r0

    return r0
  end

  def _nt_expression
    start_index = index
    if node_cache[:expression].has_key?(index)
      cached = node_cache[:expression][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_if_expression
    if r1
      r0 = r1
    else
      r2 = _nt_case_expression
      if r2
        r0 = r2
      else
        r3 = _nt_binary_expression
        if r3
          r0 = r3
        else
          r4 = _nt_negated_expression
          if r4
            r0 = r4
          else
            r5 = _nt_unary_expression
            if r5
              r0 = r5
            else
              self.index = i0
              r0 = nil
            end
          end
        end
      end
    end

    node_cache[:expression][start_index] = r0

    return r0
  end

  module BinaryExpression0
    def operand_1
      elements[0]
    end

    def space
      elements[1]
    end

    def operator
      elements[2]
    end

    def space
      elements[3]
    end

    def operand_2
      elements[4]
    end

    def binary_expression
      elements[5]
    end
  end

  module BinaryExpression1
    def operand_1
      elements[0]
    end

    def space
      elements[1]
    end

    def operator
      elements[2]
    end

    def space
      elements[3]
    end

    def operand_2
      elements[4]
    end
  end

  def _nt_binary_expression
    start_index = index
    if node_cache[:binary_expression].has_key?(index)
      cached = node_cache[:binary_expression][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_unary_expression
    s1 << r2
    if r2
      r3 = _nt_space
      s1 << r3
      if r3
        r4 = _nt_binary_expression_op
        s1 << r4
        if r4
          r5 = _nt_space
          s1 << r5
          if r5
            r6 = _nt_unary_expression
            s1 << r6
            if r6
              r7 = _nt_binary_expression
              s1 << r7
            end
          end
        end
      end
    end
    if s1.last
      r1 = (BinaryOperation).new(input, i1...index, s1)
      r1.extend(BinaryExpression0)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i8, s8 = index, []
      r9 = _nt_unary_expression
      s8 << r9
      if r9
        r10 = _nt_space
        s8 << r10
        if r10
          r11 = _nt_binary_expression_op
          s8 << r11
          if r11
            r12 = _nt_space
            s8 << r12
            if r12
              r13 = _nt_unary_expression
              s8 << r13
            end
          end
        end
      end
      if s8.last
        r8 = (BinaryOperation).new(input, i8...index, s8)
        r8.extend(BinaryExpression1)
      else
        self.index = i8
        r8 = nil
      end
      if r8
        r0 = r8
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:binary_expression][start_index] = r0

    return r0
  end

  module NegatedExpression0
    def expression
      elements[1]
    end
  end

  module NegatedExpression1
    def eval(env = Environment.new)
      !expression.eval(env)
    end
  end

  def _nt_negated_expression
    start_index = index
    if node_cache[:negated_expression].has_key?(index)
      cached = node_cache[:negated_expression][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index("!", index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure("!")
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_expression
      s0 << r2
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(NegatedExpression0)
      r0.extend(NegatedExpression1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:negated_expression][start_index] = r0

    return r0
  end

  def _nt_unary_expression
    start_index = index
    if node_cache[:unary_expression].has_key?(index)
      cached = node_cache[:unary_expression][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_require_directive
    if r1
      r0 = r1
    else
      r2 = _nt_definition
      if r2
        r0 = r2
      else
        r3 = _nt_comparative
        if r3
          r0 = r3
        else
          r4 = _nt_additive
          if r4
            r0 = r4
          else
            self.index = i0
            r0 = nil
          end
        end
      end
    end

    node_cache[:unary_expression][start_index] = r0

    return r0
  end

  module Definition0
    def variable
      elements[0]
    end

    def space
      elements[1]
    end

    def space
      elements[3]
    end

    def expression
      elements[4]
    end
  end

  module Definition1
    def eval(env = Environment.new)
      env[variable.name] = expression.eval(env)
    end

    def to_s(env = Environment.new)
      "#{variable.name} = #{expression.eval(env)}"
    end
  end

  def _nt_definition
    start_index = index
    if node_cache[:definition].has_key?(index)
      cached = node_cache[:definition][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_variable
    s0 << r1
    if r1
      r2 = _nt_space
      s0 << r2
      if r2
        if input.index('=', index) == index
          r3 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('=')
          r3 = nil
        end
        s0 << r3
        if r3
          r4 = _nt_space
          s0 << r4
          if r4
            r5 = _nt_expression
            s0 << r5
          end
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(Definition0)
      r0.extend(Definition1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:definition][start_index] = r0

    return r0
  end

  module IfExpression0
    def elsif_expression_list
      elements[0]
    end

    def SPACE
      elements[1]
    end
  end

  module IfExpression1
    def SPACE
      elements[1]
    end

    def statement_list
      elements[2]
    end

    def SPACE
      elements[3]
    end
  end

  module IfExpression2
    def space
      elements[1]
    end

    def space
      elements[3]
    end

    def if_exp
      elements[4]
    end

    def space
      elements[5]
    end

    def SPACE
      elements[7]
    end

    def if_branch
      elements[8]
    end

    def space
      elements[9]
    end

    def elsif_branches
      elements[10]
    end

    def else_branch
      elements[11]
    end

  end

  module IfExpression3
    def eval(env = Environment.new)
      return if_branch.eval(env) if if_exp.eval(env)
      elsif_expressions.each do |e|
        return e.statement_list.eval(env) if e.elsif_exp.eval(env)
      end
      (else_branch && !else_branch.empty?) ? else_branch.statement_list.eval(env) : nil
    end

    def elsif_expressions(env = Environment.new)
      (elsif_branches && !elsif_branches.empty?) ? elsif_branches.elsif_expression_list.elsif_expressions : []
    end
  end

  def _nt_if_expression
    start_index = index
    if node_cache[:if_expression].has_key?(index)
      cached = node_cache[:if_expression][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('if', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 2))
      @index += 2
    else
      terminal_parse_failure('if')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_space
      s0 << r2
      if r2
        if input.index('(', index) == index
          r3 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('(')
          r3 = nil
        end
        s0 << r3
        if r3
          r4 = _nt_space
          s0 << r4
          if r4
            r5 = _nt_expression
            s0 << r5
            if r5
              r6 = _nt_space
              s0 << r6
              if r6
                if input.index(')', index) == index
                  r7 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure(')')
                  r7 = nil
                end
                s0 << r7
                if r7
                  r8 = _nt_SPACE
                  s0 << r8
                  if r8
                    r9 = _nt_statement_list
                    s0 << r9
                    if r9
                      r10 = _nt_space
                      s0 << r10
                      if r10
                        i12, s12 = index, []
                        r13 = _nt_elsif_expression_list
                        s12 << r13
                        if r13
                          r14 = _nt_SPACE
                          s12 << r14
                        end
                        if s12.last
                          r12 = (SyntaxNode).new(input, i12...index, s12)
                          r12.extend(IfExpression0)
                        else
                          self.index = i12
                          r12 = nil
                        end
                        if r12
                          r11 = r12
                        else
                          r11 = SyntaxNode.new(input, index...index)
                        end
                        s0 << r11
                        if r11
                          i16, s16 = index, []
                          if input.index('else', index) == index
                            r17 = (SyntaxNode).new(input, index...(index + 4))
                            @index += 4
                          else
                            terminal_parse_failure('else')
                            r17 = nil
                          end
                          s16 << r17
                          if r17
                            r18 = _nt_SPACE
                            s16 << r18
                            if r18
                              r19 = _nt_statement_list
                              s16 << r19
                              if r19
                                r20 = _nt_SPACE
                                s16 << r20
                              end
                            end
                          end
                          if s16.last
                            r16 = (SyntaxNode).new(input, i16...index, s16)
                            r16.extend(IfExpression1)
                          else
                            self.index = i16
                            r16 = nil
                          end
                          if r16
                            r15 = r16
                          else
                            r15 = SyntaxNode.new(input, index...index)
                          end
                          s0 << r15
                          if r15
                            if input.index('end', index) == index
                              r21 = (SyntaxNode).new(input, index...(index + 3))
                              @index += 3
                            else
                              terminal_parse_failure('end')
                              r21 = nil
                            end
                            s0 << r21
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(IfExpression2)
      r0.extend(IfExpression3)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:if_expression][start_index] = r0

    return r0
  end

  module ElsifExpression0
    def space
      elements[1]
    end

    def space
      elements[3]
    end

    def elsif_exp
      elements[4]
    end

    def space
      elements[5]
    end

    def space
      elements[7]
    end

    def statement_list
      elements[8]
    end
  end

  module ElsifExpression1

    def eval(env = Environment.new)
      statement_list.eval(env)
    end
  end

  def _nt_elsif_expression
    start_index = index
    if node_cache[:elsif_expression].has_key?(index)
      cached = node_cache[:elsif_expression][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('elsif', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 5))
      @index += 5
    else
      terminal_parse_failure('elsif')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_space
      s0 << r2
      if r2
        if input.index('(', index) == index
          r3 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('(')
          r3 = nil
        end
        s0 << r3
        if r3
          r4 = _nt_space
          s0 << r4
          if r4
            r5 = _nt_expression
            s0 << r5
            if r5
              r6 = _nt_space
              s0 << r6
              if r6
                if input.index(')', index) == index
                  r7 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure(')')
                  r7 = nil
                end
                s0 << r7
                if r7
                  r8 = _nt_space
                  s0 << r8
                  if r8
                    r9 = _nt_statement_list
                    s0 << r9
                  end
                end
              end
            end
          end
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(ElsifExpression0)
      r0.extend(ElsifExpression1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:elsif_expression][start_index] = r0

    return r0
  end

  module ElsifExpressionList0
    def SPACE
      elements[0]
    end

    def elsif_expression
      elements[1]
    end
  end

  module ElsifExpressionList1
    def elsif_expression
      elements[0]
    end

    def tail
      elements[1]
    end
  end

  module ElsifExpressionList2
    def eval(env = Environment.new)
      elsif_expressions.inject([]) do |exprs, expr|
        exprs << expr.eval(env)
      end
    end

    def elsif_expressions
      [ elsif_expression ] + tail.elements.map { |e| e.elsif_expression }
    end
  end

  def _nt_elsif_expression_list
    start_index = index
    if node_cache[:elsif_expression_list].has_key?(index)
      cached = node_cache[:elsif_expression_list][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_elsif_expression
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        i3, s3 = index, []
        r4 = _nt_SPACE
        s3 << r4
        if r4
          r5 = _nt_elsif_expression
          s3 << r5
        end
        if s3.last
          r3 = (SyntaxNode).new(input, i3...index, s3)
          r3.extend(ElsifExpressionList0)
        else
          self.index = i3
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = SyntaxNode.new(input, i2...index, s2)
      s0 << r2
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(ElsifExpressionList1)
      r0.extend(ElsifExpressionList2)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:elsif_expression_list][start_index] = r0

    return r0
  end

  module CaseExpression0
    def case_keyword
      elements[0]
    end

    def SPACE
      elements[1]
    end

    def case_exp
      elements[2]
    end

    def SPACE
      elements[3]
    end

    def when_expression_list
      elements[4]
    end

    def SPACE
      elements[5]
    end

    def SPACE
      elements[7]
    end

    def else_exp
      elements[8]
    end

    def SPACE
      elements[9]
    end

    def end_keyword
      elements[10]
    end
  end

  module CaseExpression1
    def eval(env = Environment.new)
      case_val = case_exp.eval(env)
      else_val = else_exp.eval(env)
      Kernel.eval <<-CASE_STMT
        lambda do
          case #{case_val.is_a?(String) ? "'#{case_val}'" : case_val}
            #{ruby_when_expressions(env)}
            else #{else_val.is_a?(String) ? "'#{else_val}'" : else_val}
          end
        end [] # call this lambda immediately   
      CASE_STMT
    end

    def ruby_when_expressions(env = Environment.new)
      when_expression_list.eval(env).inject('') do |ruby, e|
        # possible string values have been wrapped in '' already
        ruby << "when #{e[:condition]} then #{e[:expression]} "
      end
    end
  end

  def _nt_case_expression
    start_index = index
    if node_cache[:case_expression].has_key?(index)
      cached = node_cache[:case_expression][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_case_keyword
    s0 << r1
    if r1
      r2 = _nt_SPACE
      s0 << r2
      if r2
        r3 = _nt_expression
        s0 << r3
        if r3
          r4 = _nt_SPACE
          s0 << r4
          if r4
            r5 = _nt_when_expression_list
            s0 << r5
            if r5
              r6 = _nt_SPACE
              s0 << r6
              if r6
                if input.index('else', index) == index
                  r7 = (SyntaxNode).new(input, index...(index + 4))
                  @index += 4
                else
                  terminal_parse_failure('else')
                  r7 = nil
                end
                s0 << r7
                if r7
                  r8 = _nt_SPACE
                  s0 << r8
                  if r8
                    r9 = _nt_statement_list
                    s0 << r9
                    if r9
                      r10 = _nt_SPACE
                      s0 << r10
                      if r10
                        r11 = _nt_end_keyword
                        s0 << r11
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(CaseExpression0)
      r0.extend(CaseExpression1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:case_expression][start_index] = r0

    return r0
  end

  module WhenExpression0
    def when_keyword
      elements[0]
    end

    def SPACE
      elements[1]
    end

    def when_exp
      elements[2]
    end

    def SPACE
      elements[3]
    end

    def then_keyword
      elements[4]
    end

    def SPACE
      elements[5]
    end

    def statement_list
      elements[6]
    end
  end

  module WhenExpression1
    def eval(env = Environment.new)
      condition = when_exp.eval(env)
      expression = statement_list.eval(env)
      { 
        # use '' instead of "" since we don't care about var replacement now
        :condition =>  (condition.is_a?(String)  ? "'#{condition}'"  : condition),
        :expression => (expression.is_a?(String) ? "'#{expression}'" : expression)
      }
    end
  end

  def _nt_when_expression
    start_index = index
    if node_cache[:when_expression].has_key?(index)
      cached = node_cache[:when_expression][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_when_keyword
    s0 << r1
    if r1
      r2 = _nt_SPACE
      s0 << r2
      if r2
        r3 = _nt_expression
        s0 << r3
        if r3
          r4 = _nt_SPACE
          s0 << r4
          if r4
            r5 = _nt_then_keyword
            s0 << r5
            if r5
              r6 = _nt_SPACE
              s0 << r6
              if r6
                r7 = _nt_statement_list
                s0 << r7
              end
            end
          end
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(WhenExpression0)
      r0.extend(WhenExpression1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:when_expression][start_index] = r0

    return r0
  end

  module WhenExpressionList0
    def SPACE
      elements[0]
    end

    def when_expression
      elements[1]
    end
  end

  module WhenExpressionList1
    def when_expression
      elements[0]
    end

    def more_when_expressions
      elements[1]
    end
  end

  module WhenExpressionList2
    def eval(env = Environment.new)
      when_expressions.inject([]) do |exprs, expr|
        exprs << expr.eval(env)
      end
    end

    def when_expressions
      [ when_expression ] + more_when_expressions.elements.map { |e| e.when_expression }
    end
  end

  def _nt_when_expression_list
    start_index = index
    if node_cache[:when_expression_list].has_key?(index)
      cached = node_cache[:when_expression_list][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_when_expression
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        i3, s3 = index, []
        r4 = _nt_SPACE
        s3 << r4
        if r4
          r5 = _nt_when_expression
          s3 << r5
        end
        if s3.last
          r3 = (SyntaxNode).new(input, i3...index, s3)
          r3.extend(WhenExpressionList0)
        else
          self.index = i3
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = SyntaxNode.new(input, i2...index, s2)
      s0 << r2
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(WhenExpressionList1)
      r0.extend(WhenExpressionList2)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:when_expression_list][start_index] = r0

    return r0
  end

  module Application0
    def space
      elements[0]
    end

    def actual_parameter_list
      elements[1]
    end
  end

  module Application1
    def operator
      elements[0]
    end

    def space
      elements[1]
    end

    def first_application
      elements[2]
    end

    def more_applications
      elements[3]
    end
  end

  module Application2
    def eval(env = Environment.new)
      left_associative_apply(operator, env)
    end

    def left_associative_apply(operator, env)
      applications.each do |actual_parameter_list|
        actuals = actual_parameter_list.eval(env)
        unless operator.instance_of?(Trxl::Function::Closure)
          operator = operator.eval(env)
        end
        operator = operator.apply(actuals)
      end
      operator
    end

    def applications
      [ first_application ] + more_applications.elements.map { |e| e.actual_parameter_list }
    end

    def to_s(env = Environment.new)
      text_value
    end
  end

  def _nt_application
    start_index = index
    if node_cache[:application].has_key?(index)
      cached = node_cache[:application][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_operator
    s0 << r1
    if r1
      r2 = _nt_space
      s0 << r2
      if r2
        r3 = _nt_actual_parameter_list
        s0 << r3
        if r3
          s4, i4 = [], index
          loop do
            i5, s5 = index, []
            r6 = _nt_space
            s5 << r6
            if r6
              r7 = _nt_actual_parameter_list
              s5 << r7
            end
            if s5.last
              r5 = (SyntaxNode).new(input, i5...index, s5)
              r5.extend(Application0)
            else
              self.index = i5
              r5 = nil
            end
            if r5
              s4 << r5
            else
              break
            end
          end
          r4 = SyntaxNode.new(input, i4...index, s4)
          s0 << r4
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(Application1)
      r0.extend(Application2)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:application][start_index] = r0

    return r0
  end

  def _nt_operator
    start_index = index
    if node_cache[:operator].has_key?(index)
      cached = node_cache[:operator][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_function
    if r1
      r0 = r1
    else
      r2 = _nt_variable
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:operator][start_index] = r0

    return r0
  end

  module Function0
    def formal_parameter_list
      elements[1]
    end

    def space
      elements[2]
    end

    def space
      elements[4]
    end

    def body
      elements[5]
    end

    def space
      elements[6]
    end

  end

  def _nt_function
    start_index = index
    if node_cache[:function].has_key?(index)
      cached = node_cache[:function][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('fun', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 3))
      @index += 3
    else
      terminal_parse_failure('fun')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_formal_parameter_list
      s0 << r2
      if r2
        r3 = _nt_space
        s0 << r3
        if r3
          if input.index('{', index) == index
            r4 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('{')
            r4 = nil
          end
          s0 << r4
          if r4
            r5 = _nt_space
            s0 << r5
            if r5
              r6 = _nt_statement_list
              s0 << r6
              if r6
                r7 = _nt_space
                s0 << r7
                if r7
                  if input.index('}', index) == index
                    r8 = (SyntaxNode).new(input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure('}')
                    r8 = nil
                  end
                  s0 << r8
                end
              end
            end
          end
        end
      end
    end
    if s0.last
      r0 = (Function).new(input, i0...index, s0)
      r0.extend(Function0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:function][start_index] = r0

    return r0
  end

  module FormalParameterList0
    def space
      elements[0]
    end

    def space
      elements[2]
    end

    def variable
      elements[3]
    end
  end

  module FormalParameterList1
    def variable
      elements[1]
    end

    def more_variables
      elements[2]
    end

    def space
      elements[3]
    end

  end

  module FormalParameterList2
    def bind(args, env = Environment.new)
      if (a = args.length) < (f = variables.length)
        raise WrongNumberOfArgumentsException, "#{a} instead of #{f}"
      end
      env.merge!(variables.zip(args).inject({}) do |bindings, param|
        bindings.merge(param.first.name => param.last)
      end)
      # store arguments array in scope, javascript like
      env.merge!(:arguments => args)
    end

    def variables
      [variable] + more_variables.elements.map { |e| e.variable }
    end

    def length
      variables.length
    end

    def to_s(env = Environment.new)
      "(#{variables.map { |var| var.text_value }.join(',')})"
    end
  end

  module FormalParameterList3
    def space
      elements[1]
    end

  end

  module FormalParameterList4
    def bind(args, env)
      # store arguments array in scope, javascript like
      env.merge!(:arguments => args)
    end

    def to_s(env = Environment.new)
      '()'
    end
  end

  def _nt_formal_parameter_list
    start_index = index
    if node_cache[:formal_parameter_list].has_key?(index)
      cached = node_cache[:formal_parameter_list][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if input.index('(', index) == index
      r2 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('(')
      r2 = nil
    end
    s1 << r2
    if r2
      r3 = _nt_variable
      s1 << r3
      if r3
        s4, i4 = [], index
        loop do
          i5, s5 = index, []
          r6 = _nt_space
          s5 << r6
          if r6
            if input.index(',', index) == index
              r7 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure(',')
              r7 = nil
            end
            s5 << r7
            if r7
              r8 = _nt_space
              s5 << r8
              if r8
                r9 = _nt_variable
                s5 << r9
              end
            end
          end
          if s5.last
            r5 = (SyntaxNode).new(input, i5...index, s5)
            r5.extend(FormalParameterList0)
          else
            self.index = i5
            r5 = nil
          end
          if r5
            s4 << r5
          else
            break
          end
        end
        r4 = SyntaxNode.new(input, i4...index, s4)
        s1 << r4
        if r4
          r10 = _nt_space
          s1 << r10
          if r10
            if input.index(')', index) == index
              r11 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure(')')
              r11 = nil
            end
            s1 << r11
          end
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(FormalParameterList1)
      r1.extend(FormalParameterList2)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i12, s12 = index, []
      if input.index('(', index) == index
        r13 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure('(')
        r13 = nil
      end
      s12 << r13
      if r13
        r14 = _nt_space
        s12 << r14
        if r14
          if input.index(')', index) == index
            r15 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure(')')
            r15 = nil
          end
          s12 << r15
        end
      end
      if s12.last
        r12 = (SyntaxNode).new(input, i12...index, s12)
        r12.extend(FormalParameterList3)
        r12.extend(FormalParameterList4)
      else
        self.index = i12
        r12 = nil
      end
      if r12
        r0 = r12
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:formal_parameter_list][start_index] = r0

    return r0
  end

  module ActualParameterList0
    def space
      elements[1]
    end

    def expression_list
      elements[2]
    end

    def space
      elements[3]
    end

  end

  module ActualParameterList1

    def eval(env = Environment.new)
      expression_list.eval(env)
    end

    def to_s(env = Environment.new)
      "(#{expression_list.to_s(env)})"
    end
  end

  module ActualParameterList2
    def space
      elements[1]
    end

  end

  module ActualParameterList3
    def eval(env = Environment.new)
      []
    end
 
    def to_s(env = Environment.new)
      '()'
    end
  end

  def _nt_actual_parameter_list
    start_index = index
    if node_cache[:actual_parameter_list].has_key?(index)
      cached = node_cache[:actual_parameter_list][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if input.index('(', index) == index
      r2 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('(')
      r2 = nil
    end
    s1 << r2
    if r2
      r3 = _nt_space
      s1 << r3
      if r3
        r4 = _nt_expression_list
        s1 << r4
        if r4
          r5 = _nt_space
          s1 << r5
          if r5
            if input.index(')', index) == index
              r6 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure(')')
              r6 = nil
            end
            s1 << r6
          end
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(ActualParameterList0)
      r1.extend(ActualParameterList1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i7, s7 = index, []
      if input.index('(', index) == index
        r8 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure('(')
        r8 = nil
      end
      s7 << r8
      if r8
        r9 = _nt_space
        s7 << r9
        if r9
          if input.index(')', index) == index
            r10 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure(')')
            r10 = nil
          end
          s7 << r10
        end
      end
      if s7.last
        r7 = (SyntaxNode).new(input, i7...index, s7)
        r7.extend(ActualParameterList2)
        r7.extend(ActualParameterList3)
      else
        self.index = i7
        r7 = nil
      end
      if r7
        r0 = r7
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:actual_parameter_list][start_index] = r0

    return r0
  end

  def _nt_string_literal
    start_index = index
    if node_cache[:string_literal].has_key?(index)
      cached = node_cache[:string_literal][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_single_quoted_string
    if r1
      r0 = r1
    else
      r2 = _nt_double_quoted_string
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:string_literal][start_index] = r0

    return r0
  end

  module DoubleQuotedString0
  end

  module DoubleQuotedString1
    def string
      elements[1]
    end

  end

  module DoubleQuotedString2
    def eval(env = Environment.new)
      string.text_value
    end
  end

  def _nt_double_quoted_string
    start_index = index
    if node_cache[:double_quoted_string].has_key?(index)
      cached = node_cache[:double_quoted_string][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('"', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('"')
      r1 = nil
    end
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        i3, s3 = index, []
        i4 = index
        if input.index('"', index) == index
          r5 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('"')
          r5 = nil
        end
        if r5
          r4 = nil
        else
          self.index = i4
          r4 = SyntaxNode.new(input, index...index)
        end
        s3 << r4
        if r4
          i6 = index
          if input.index("\\\\", index) == index
            r7 = (SyntaxNode).new(input, index...(index + 2))
            @index += 2
          else
            terminal_parse_failure("\\\\")
            r7 = nil
          end
          if r7
            r6 = r7
          else
            if input.index('\"', index) == index
              r8 = (SyntaxNode).new(input, index...(index + 2))
              @index += 2
            else
              terminal_parse_failure('\"')
              r8 = nil
            end
            if r8
              r6 = r8
            else
              if index < input_length
                r9 = (SyntaxNode).new(input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure("any character")
                r9 = nil
              end
              if r9
                r6 = r9
              else
                self.index = i6
                r6 = nil
              end
            end
          end
          s3 << r6
        end
        if s3.last
          r3 = (SyntaxNode).new(input, i3...index, s3)
          r3.extend(DoubleQuotedString0)
        else
          self.index = i3
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = SyntaxNode.new(input, i2...index, s2)
      s0 << r2
      if r2
        if input.index('"', index) == index
          r10 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('"')
          r10 = nil
        end
        s0 << r10
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(DoubleQuotedString1)
      r0.extend(DoubleQuotedString2)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:double_quoted_string][start_index] = r0

    return r0
  end

  module SingleQuotedString0
  end

  module SingleQuotedString1
    def string
      elements[1]
    end

  end

  module SingleQuotedString2
    def eval(env = Environment.new)
      string.text_value
    end
  end

  def _nt_single_quoted_string
    start_index = index
    if node_cache[:single_quoted_string].has_key?(index)
      cached = node_cache[:single_quoted_string][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index("'", index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure("'")
      r1 = nil
    end
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        i3, s3 = index, []
        i4 = index
        if input.index("'", index) == index
          r5 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("'")
          r5 = nil
        end
        if r5
          r4 = nil
        else
          self.index = i4
          r4 = SyntaxNode.new(input, index...index)
        end
        s3 << r4
        if r4
          i6 = index
          if input.index("\\\\", index) == index
            r7 = (SyntaxNode).new(input, index...(index + 2))
            @index += 2
          else
            terminal_parse_failure("\\\\")
            r7 = nil
          end
          if r7
            r6 = r7
          else
            if input.index("\\'", index) == index
              r8 = (SyntaxNode).new(input, index...(index + 2))
              @index += 2
            else
              terminal_parse_failure("\\'")
              r8 = nil
            end
            if r8
              r6 = r8
            else
              if index < input_length
                r9 = (SyntaxNode).new(input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure("any character")
                r9 = nil
              end
              if r9
                r6 = r9
              else
                self.index = i6
                r6 = nil
              end
            end
          end
          s3 << r6
        end
        if s3.last
          r3 = (SyntaxNode).new(input, i3...index, s3)
          r3.extend(SingleQuotedString0)
        else
          self.index = i3
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = SyntaxNode.new(input, i2...index, s2)
      s0 << r2
      if r2
        if input.index("'", index) == index
          r10 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("'")
          r10 = nil
        end
        s0 << r10
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(SingleQuotedString1)
      r0.extend(SingleQuotedString2)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:single_quoted_string][start_index] = r0

    return r0
  end

  module HashLiteral0
    def space
      elements[1]
    end

    def hash_entry_list
      elements[2]
    end

    def space
      elements[3]
    end

  end

  module HashLiteral1

    def eval(env = Environment.new)
      hash_entry_list.eval(env)
    end

    def to_s(env = Environment.new)
      "(#{hash_entry_list.to_s(env)})"
    end
  end

  module HashLiteral2
    def eval(env = Environment.new)
      {}
    end
 
    def to_s(env = Environment.new)
      text_value
    end
  end

  def _nt_hash_literal
    start_index = index
    if node_cache[:hash_literal].has_key?(index)
      cached = node_cache[:hash_literal][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if input.index('{', index) == index
      r2 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('{')
      r2 = nil
    end
    s1 << r2
    if r2
      r3 = _nt_space
      s1 << r3
      if r3
        r4 = _nt_hash_entry_list
        s1 << r4
        if r4
          r5 = _nt_space
          s1 << r5
          if r5
            if input.index('}', index) == index
              r6 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure('}')
              r6 = nil
            end
            s1 << r6
          end
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(HashLiteral0)
      r1.extend(HashLiteral1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      if input.index('{}', index) == index
        r7 = (SyntaxNode).new(input, index...(index + 2))
        r7.extend(HashLiteral2)
        @index += 2
      else
        terminal_parse_failure('{}')
        r7 = nil
      end
      if r7
        r0 = r7
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:hash_literal][start_index] = r0

    return r0
  end

  module HashEntryList0
    def space
      elements[0]
    end

    def space
      elements[2]
    end

    def hash_entry
      elements[3]
    end
  end

  module HashEntryList1
    def hash_entry
      elements[0]
    end

    def tail
      elements[1]
    end

  end

  module HashEntryList2
    def eval(env = Environment.new)
      hash_entries.inject({}) do |hash, entry|
        hash.merge(entry.eval(env))
      end
    end

    def hash_entries
      [ hash_entry ] + tail.elements.map { |e| e.hash_entry }
    end
  end

  def _nt_hash_entry_list
    start_index = index
    if node_cache[:hash_entry_list].has_key?(index)
      cached = node_cache[:hash_entry_list][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_hash_entry
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        i3, s3 = index, []
        r4 = _nt_space
        s3 << r4
        if r4
          if input.index(',', index) == index
            r5 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure(',')
            r5 = nil
          end
          s3 << r5
          if r5
            r6 = _nt_space
            s3 << r6
            if r6
              r7 = _nt_hash_entry
              s3 << r7
            end
          end
        end
        if s3.last
          r3 = (SyntaxNode).new(input, i3...index, s3)
          r3.extend(HashEntryList0)
        else
          self.index = i3
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = SyntaxNode.new(input, i2...index, s2)
      s0 << r2
      if r2
        if input.index(',', index) == index
          r9 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure(',')
          r9 = nil
        end
        if r9
          r8 = r9
        else
          r8 = SyntaxNode.new(input, index...index)
        end
        s0 << r8
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(HashEntryList1)
      r0.extend(HashEntryList2)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:hash_entry_list][start_index] = r0

    return r0
  end

  module HashEntry0
    def key
      elements[0]
    end

    def space
      elements[1]
    end

    def space
      elements[3]
    end

    def value
      elements[4]
    end
  end

  module HashEntry1
    def eval(env = Environment.new)
      { key.eval(env) => value.eval(env) }
    end
 
    def to_s(env = Environment.new)
      text_value
    end
  end

  def _nt_hash_entry
    start_index = index
    if node_cache[:hash_entry].has_key?(index)
      cached = node_cache[:hash_entry][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_expression
    s0 << r1
    if r1
      r2 = _nt_space
      s0 << r2
      if r2
        if input.index('=>', index) == index
          r3 = (SyntaxNode).new(input, index...(index + 2))
          @index += 2
        else
          terminal_parse_failure('=>')
          r3 = nil
        end
        s0 << r3
        if r3
          r4 = _nt_space
          s0 << r4
          if r4
            r5 = _nt_expression
            s0 << r5
          end
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(HashEntry0)
      r0.extend(HashEntry1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:hash_entry][start_index] = r0

    return r0
  end

  module ArrayLiteral0
    def space
      elements[1]
    end

    def expression_list
      elements[2]
    end

    def space
      elements[3]
    end

  end

  module ArrayLiteral1

    def eval(env = Environment.new)
      expression_list.eval(env)
    end

    def to_s(env = Environment.new)
      "(#{expression_list.to_s(env)})"
    end
  end

  module ArrayLiteral2
    def eval(env = Environment.new)
      []
    end
 
    def to_s(env = Environment.new)
      text_value
    end
  end

  def _nt_array_literal
    start_index = index
    if node_cache[:array_literal].has_key?(index)
      cached = node_cache[:array_literal][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if input.index('[', index) == index
      r2 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('[')
      r2 = nil
    end
    s1 << r2
    if r2
      r3 = _nt_space
      s1 << r3
      if r3
        r4 = _nt_expression_list
        s1 << r4
        if r4
          r5 = _nt_space
          s1 << r5
          if r5
            if input.index(']', index) == index
              r6 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure(']')
              r6 = nil
            end
            s1 << r6
          end
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(ArrayLiteral0)
      r1.extend(ArrayLiteral1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      if input.index('[]', index) == index
        r7 = (SyntaxNode).new(input, index...(index + 2))
        r7.extend(ArrayLiteral2)
        @index += 2
      else
        terminal_parse_failure('[]')
        r7 = nil
      end
      if r7
        r0 = r7
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:array_literal][start_index] = r0

    return r0
  end

  module RangeLiteral0
    def lower
      elements[0]
    end

    def space
      elements[1]
    end

    def space
      elements[3]
    end

    def upper
      elements[4]
    end
  end

  module RangeLiteral1
    def eval(env = Environment.new)
      lower_bound = lower.eval(env)
      upper_bound = upper.eval(env)
      if lower_bound.class == upper_bound.class && !lower_bound.is_a?(Array)
        range_op = elements[2].text_value
        omit_upper = (range_op == '...') ? true : false
        Range.new(lower.eval(env), upper.eval(env), omit_upper).to_a
      else
        raise Trxl::InvalidOperationException, "Range boundary is not of type String or Integer"
      end
    end

    def range_type(env = Environment.new)
      case elements[0].eval(env)
        when Fixnum then :numeric
        when String then :string
        else :unknown
      end
    end

    def to_s(env = Environment.new)
      text_value
    end
  end

  def _nt_range_literal
    start_index = index
    if node_cache[:range_literal].has_key?(index)
      cached = node_cache[:range_literal][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    i1 = index
    r2 = _nt_variable
    if r2
      r1 = r2
    else
      r3 = _nt_integer_number
      if r3
        r1 = r3
      else
        r4 = _nt_string_literal
        if r4
          r1 = r4
        else
          self.index = i1
          r1 = nil
        end
      end
    end
    s0 << r1
    if r1
      r5 = _nt_space
      s0 << r5
      if r5
        i6 = index
        if input.index('...', index) == index
          r7 = (SyntaxNode).new(input, index...(index + 3))
          @index += 3
        else
          terminal_parse_failure('...')
          r7 = nil
        end
        if r7
          r6 = r7
        else
          if input.index('..', index) == index
            r8 = (SyntaxNode).new(input, index...(index + 2))
            @index += 2
          else
            terminal_parse_failure('..')
            r8 = nil
          end
          if r8
            r6 = r8
          else
            self.index = i6
            r6 = nil
          end
        end
        s0 << r6
        if r6
          r9 = _nt_space
          s0 << r9
          if r9
            i10 = index
            r11 = _nt_variable
            if r11
              r10 = r11
            else
              r12 = _nt_integer_number
              if r12
                r10 = r12
              else
                r13 = _nt_string_literal
                if r13
                  r10 = r13
                else
                  self.index = i10
                  r10 = nil
                end
              end
            end
            s0 << r10
          end
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(RangeLiteral0)
      r0.extend(RangeLiteral1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:range_literal][start_index] = r0

    return r0
  end

  module ExpressionList0
    def space
      elements[0]
    end

    def space
      elements[2]
    end

    def expression
      elements[3]
    end
  end

  module ExpressionList1
    def expression
      elements[0]
    end

    def more_expressions
      elements[1]
    end
  end

  module ExpressionList2

    def eval(env = Environment.new)
      expressions.inject([]) { |arr, exp| arr << exp.eval(env) }
    end

    def expressions
      [ expression ] + more_expressions.elements.map { |e| e.expression }
    end

    def length
      expressions.length
    end

    def to_s(env = Environment.new)
      "#{expressions.map { |p| p.text_value }.join(',')}"
    end
  end

  def _nt_expression_list
    start_index = index
    if node_cache[:expression_list].has_key?(index)
      cached = node_cache[:expression_list][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_expression
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        i3, s3 = index, []
        r4 = _nt_space
        s3 << r4
        if r4
          if input.index(',', index) == index
            r5 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure(',')
            r5 = nil
          end
          s3 << r5
          if r5
            r6 = _nt_space
            s3 << r6
            if r6
              r7 = _nt_expression
              s3 << r7
            end
          end
        end
        if s3.last
          r3 = (SyntaxNode).new(input, i3...index, s3)
          r3.extend(ExpressionList0)
        else
          self.index = i3
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = SyntaxNode.new(input, i2...index, s2)
      s0 << r2
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(ExpressionList1)
      r0.extend(ExpressionList2)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:expression_list][start_index] = r0

    return r0
  end

  module Comparative0
    def operand_1
      elements[0]
    end

    def space
      elements[1]
    end

    def operator
      elements[2]
    end

    def space
      elements[3]
    end

    def operand_2
      elements[4]
    end
  end

  def _nt_comparative
    start_index = index
    if node_cache[:comparative].has_key?(index)
      cached = node_cache[:comparative][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_additive
    s0 << r1
    if r1
      r2 = _nt_space
      s0 << r2
      if r2
        r3 = _nt_equality_op
        s0 << r3
        if r3
          r4 = _nt_space
          s0 << r4
          if r4
            r5 = _nt_additive
            s0 << r5
          end
        end
      end
    end
    if s0.last
      r0 = (BinaryOperation).new(input, i0...index, s0)
      r0.extend(Comparative0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:comparative][start_index] = r0

    return r0
  end

  module BinaryExpressionOp0

    def apply(a, b)
      if a.is_a?(Array)
        super
      else
        raise Trxl::InvalidOperationException, "Left operand is not an Array"
      end
    end
    
    # override default behavior since it's not possible to push into nil
    def lhs_nil_allowed?
      false
    end
  end

  def _nt_binary_expression_op
    start_index = index
    if node_cache[:binary_expression_op].has_key?(index)
      cached = node_cache[:binary_expression_op][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    if input.index('&&', index) == index
      r1 = (NilAcceptingOperator).new(input, index...(index + 2))
      @index += 2
    else
      terminal_parse_failure('&&')
      r1 = nil
    end
    if r1
      r0 = r1
    else
      if input.index('||', index) == index
        r2 = (NilAcceptingOperator).new(input, index...(index + 2))
        @index += 2
      else
        terminal_parse_failure('||')
        r2 = nil
      end
      if r2
        r0 = r2
      else
        if input.index('<<', index) == index
          r3 = (NilAcceptingOperator).new(input, index...(index + 2))
          r3.extend(BinaryExpressionOp0)
          @index += 2
        else
          terminal_parse_failure('<<')
          r3 = nil
        end
        if r3
          r0 = r3
        else
          self.index = i0
          r0 = nil
        end
      end
    end

    node_cache[:binary_expression_op][start_index] = r0

    return r0
  end

  def _nt_equality_op
    start_index = index
    if node_cache[:equality_op].has_key?(index)
      cached = node_cache[:equality_op][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    if input.index('==', index) == index
      r1 = (NilAcceptingOperator).new(input, index...(index + 2))
      @index += 2
    else
      terminal_parse_failure('==')
      r1 = nil
    end
    if r1
      r0 = r1
    else
      if input.index('!=', index) == index
        r2 = (NilAcceptingOperator).new(input, index...(index + 2))
        @index += 2
      else
        terminal_parse_failure('!=')
        r2 = nil
      end
      if r2
        r0 = r2
      else
        if input.index('<=', index) == index
          r3 = (NilRejectingOperator).new(input, index...(index + 2))
          @index += 2
        else
          terminal_parse_failure('<=')
          r3 = nil
        end
        if r3
          r0 = r3
        else
          if input.index('>=', index) == index
            r4 = (NilRejectingOperator).new(input, index...(index + 2))
            @index += 2
          else
            terminal_parse_failure('>=')
            r4 = nil
          end
          if r4
            r0 = r4
          else
            if input.index('<', index) == index
              r5 = (NilRejectingOperator).new(input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure('<')
              r5 = nil
            end
            if r5
              r0 = r5
            else
              if input.index('>', index) == index
                r6 = (NilRejectingOperator).new(input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure('>')
                r6 = nil
              end
              if r6
                r0 = r6
              else
                self.index = i0
                r0 = nil
              end
            end
          end
        end
      end
    end

    node_cache[:equality_op][start_index] = r0

    return r0
  end

  module Additive0
    def space
      elements[0]
    end

    def additive_op
      elements[1]
    end

    def space
      elements[2]
    end

    def multitive
      elements[3]
    end
  end

  module Additive1
    def multitive
      elements[0]
    end

    def tail
      elements[1]
    end
  end

  module Additive2
    def eval(env = Environment.new)
      # left associative evaluation
      additives(env).inject(multitive.eval(env)) do |result, next_op|
        next_op[0].apply(result, next_op[1])
      end
    end

    def additives(env = Environment.new)
      tail.elements.map { |e| [ e.additive_op, e.multitive.eval(env) ] }
    end
  end

  def _nt_additive
    start_index = index
    if node_cache[:additive].has_key?(index)
      cached = node_cache[:additive][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_multitive
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        i3, s3 = index, []
        r4 = _nt_space
        s3 << r4
        if r4
          r5 = _nt_additive_op
          s3 << r5
          if r5
            r6 = _nt_space
            s3 << r6
            if r6
              r7 = _nt_multitive
              s3 << r7
            end
          end
        end
        if s3.last
          r3 = (SyntaxNode).new(input, i3...index, s3)
          r3.extend(Additive0)
        else
          self.index = i3
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = SyntaxNode.new(input, i2...index, s2)
      s0 << r2
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(Additive1)
      r0.extend(Additive2)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:additive][start_index] = r0

    return r0
  end

  def _nt_additive_op
    start_index = index
    if node_cache[:additive_op].has_key?(index)
      cached = node_cache[:additive_op][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    if input.index('+', index) == index
      r1 = (NilRejectingOperator).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('+')
      r1 = nil
    end
    if r1
      r0 = r1
    else
      if input.index('-', index) == index
        r2 = (NilRejectingOperator).new(input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure('-')
        r2 = nil
      end
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:additive_op][start_index] = r0

    return r0
  end

  module Multitive0
    def space
      elements[0]
    end

    def multitive_op
      elements[1]
    end

    def space
      elements[2]
    end

    def exponential
      elements[3]
    end
  end

  module Multitive1
    def exponential
      elements[0]
    end

    def tail
      elements[1]
    end
  end

  module Multitive2
    def eval(env = Environment.new)
      # left associative evaluation
      multitives(env).inject(exponential.eval(env)) do |operand, next_op|
        op = (next_op[0].text_value == '/' ? operand.to_f : operand)
        next_op[0].apply(op, next_op[1])
      end
    end

    def multitives(env = Environment.new)
      tail.elements.map { |e| [ e.multitive_op, e.exponential.eval(env) ] }
    end
  end

  def _nt_multitive
    start_index = index
    if node_cache[:multitive].has_key?(index)
      cached = node_cache[:multitive][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_exponential
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        i3, s3 = index, []
        r4 = _nt_space
        s3 << r4
        if r4
          r5 = _nt_multitive_op
          s3 << r5
          if r5
            r6 = _nt_space
            s3 << r6
            if r6
              r7 = _nt_exponential
              s3 << r7
            end
          end
        end
        if s3.last
          r3 = (SyntaxNode).new(input, i3...index, s3)
          r3.extend(Multitive0)
        else
          self.index = i3
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = SyntaxNode.new(input, i2...index, s2)
      s0 << r2
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(Multitive1)
      r0.extend(Multitive2)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:multitive][start_index] = r0

    return r0
  end

  module MultitiveOp0

    def apply(a, b)
      begin
        result = super
        if result == 1.0 / 0 || (result.respond_to?(:nan?) && result.nan?)
          raise Trxl::DivisionByZeroError, "Division by zero: '#{a} / #{b}'"
        end
        result
      rescue ZeroDivisionError
        raise Trxl::DivisionByZeroError, "Division by zero: '#{a} / #{b}'"
      end
    end
  end

  module MultitiveOp1

    def apply(a, b)
      begin
        result = super
        if result.respond_to?(:nan?) && result.nan?
          raise Trxl::DivisionByZeroError, "Division by zero: '#{a} % #{b}'"
        end
        result
      rescue ZeroDivisionError
        raise Trxl::DivisionByZeroError, "Division by zero: '#{a} % #{b}'"
      end
    end
  end

  def _nt_multitive_op
    start_index = index
    if node_cache[:multitive_op].has_key?(index)
      cached = node_cache[:multitive_op][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    if input.index('*', index) == index
      r1 = (NilRejectingOperator).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('*')
      r1 = nil
    end
    if r1
      r0 = r1
    else
      if input.index('/', index) == index
        r2 = (NilRejectingOperator).new(input, index...(index + 1))
        r2.extend(MultitiveOp0)
        @index += 1
      else
        terminal_parse_failure('/')
        r2 = nil
      end
      if r2
        r0 = r2
      else
        if input.index('%', index) == index
          r3 = (NilRejectingOperator).new(input, index...(index + 1))
          r3.extend(MultitiveOp1)
          @index += 1
        else
          terminal_parse_failure('%')
          r3 = nil
        end
        if r3
          r0 = r3
        else
          self.index = i0
          r0 = nil
        end
      end
    end

    node_cache[:multitive_op][start_index] = r0

    return r0
  end

  module Exponential0
    def operand_1
      elements[0]
    end

    def space
      elements[1]
    end

    def operator
      elements[2]
    end

    def space
      elements[3]
    end

    def operand_2
      elements[4]
    end
  end

  def _nt_exponential
    start_index = index
    if node_cache[:exponential].has_key?(index)
      cached = node_cache[:exponential][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_primary
    s1 << r2
    if r2
      r3 = _nt_space
      s1 << r3
      if r3
        r4 = _nt_exponential_op
        s1 << r4
        if r4
          r5 = _nt_space
          s1 << r5
          if r5
            r6 = _nt_exponential
            s1 << r6
          end
        end
      end
    end
    if s1.last
      r1 = (BinaryOperation).new(input, i1...index, s1)
      r1.extend(Exponential0)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      r7 = _nt_primary
      if r7
        r0 = r7
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:exponential][start_index] = r0

    return r0
  end

  module ExponentialOp0

    def ruby_operator
      :**
    end
  end

  def _nt_exponential_op
    start_index = index
    if node_cache[:exponential_op].has_key?(index)
      cached = node_cache[:exponential_op][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index('^', index) == index
      r0 = (NilRejectingOperator).new(input, index...(index + 1))
      r0.extend(ExponentialOp0)
      @index += 1
    else
      terminal_parse_failure('^')
      r0 = nil
    end

    node_cache[:exponential_op][start_index] = r0

    return r0
  end

  module Primary0
    def eval(env = Environment.new)
      true
    end
  end

  module Primary1
    def eval(env = Environment.new)
      false
    end
  end

  module Primary2
    def eval(env = Environment.new)
      nil
    end
  end

  module Primary3
    def space
      elements[1]
    end

    def expression
      elements[2]
    end

    def space
      elements[3]
    end

  end

  module Primary4
    def eval(env = Environment.new)
      expression.eval(env)
    end
  end

  def _nt_primary
    start_index = index
    if node_cache[:primary].has_key?(index)
      cached = node_cache[:primary][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_predefined_function
    if r1
      r0 = r1
    else
      r2 = _nt_application
      if r2
        r0 = r2
      else
        r3 = _nt_function
        if r3
          r0 = r3
        else
          if input.index('TRUE', index) == index
            r4 = (SyntaxNode).new(input, index...(index + 4))
            r4.extend(Primary0)
            @index += 4
          else
            terminal_parse_failure('TRUE')
            r4 = nil
          end
          if r4
            r0 = r4
          else
            if input.index('FALSE', index) == index
              r5 = (SyntaxNode).new(input, index...(index + 5))
              r5.extend(Primary1)
              @index += 5
            else
              terminal_parse_failure('FALSE')
              r5 = nil
            end
            if r5
              r0 = r5
            else
              if input.index('NULL', index) == index
                r6 = (SyntaxNode).new(input, index...(index + 4))
                r6.extend(Primary2)
                @index += 4
              else
                terminal_parse_failure('NULL')
                r6 = nil
              end
              if r6
                r0 = r6
              else
                r7 = _nt_offset_access_exp
                if r7
                  r0 = r7
                else
                  r8 = _nt_pattern_match_exp
                  if r8
                    r0 = r8
                  else
                    r9 = _nt_array_literal
                    if r9
                      r0 = r9
                    else
                      r10 = _nt_hash_literal
                      if r10
                        r0 = r10
                      else
                        r11 = _nt_range_literal
                        if r11
                          r0 = r11
                        else
                          r12 = _nt_string_literal
                          if r12
                            r0 = r12
                          else
                            r13 = _nt_variable
                            if r13
                              r0 = r13
                            else
                              r14 = _nt_number
                              if r14
                                r0 = r14
                              else
                                i15, s15 = index, []
                                if input.index('(', index) == index
                                  r16 = (SyntaxNode).new(input, index...(index + 1))
                                  @index += 1
                                else
                                  terminal_parse_failure('(')
                                  r16 = nil
                                end
                                s15 << r16
                                if r16
                                  r17 = _nt_space
                                  s15 << r17
                                  if r17
                                    r18 = _nt_expression
                                    s15 << r18
                                    if r18
                                      r19 = _nt_space
                                      s15 << r19
                                      if r19
                                        if input.index(')', index) == index
                                          r20 = (SyntaxNode).new(input, index...(index + 1))
                                          @index += 1
                                        else
                                          terminal_parse_failure(')')
                                          r20 = nil
                                        end
                                        s15 << r20
                                      end
                                    end
                                  end
                                end
                                if s15.last
                                  r15 = (SyntaxNode).new(input, i15...index, s15)
                                  r15.extend(Primary3)
                                  r15.extend(Primary4)
                                else
                                  self.index = i15
                                  r15 = nil
                                end
                                if r15
                                  r0 = r15
                                else
                                  self.index = i0
                                  r0 = nil
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end

    node_cache[:primary][start_index] = r0

    return r0
  end

  module OffsetAccessExp0
    def variable
      elements[0]
    end

    def offset_specifier_exp
      elements[1]
    end
  end

  module OffsetAccessExp1
    def eval(env = Environment.new)
      var = variable.eval(env)
      if var.is_a?(Array) || var.is_a?(Hash) || var.is_a?(String)
        result = left_associative_apply(var, offset_specifier_exp.eval(env))
        var.is_a?(String) ? result.chr : result
      else
        msg = "Indexing is not possible for #{var.class} (only Arrays and Strings allowed)"
        raise Trxl::InvalidOperationException, msg
      end
    end
  end

  module OffsetAccessExp2
    def pattern_match_exp
      elements[0]
    end

    def offset_specifier_exp
      elements[1]
    end
  end

  module OffsetAccessExp3
    def eval(env = Environment.new)
      offsets = offset_specifier_exp.eval(env)
      ruby_array = pattern_match_exp.eval(env)
      left_associative_apply(ruby_array, offsets)
    end
  end

  module OffsetAccessExp4
    def array_literal
      elements[0]
    end

    def offset_specifier_exp
      elements[1]
    end
  end

  module OffsetAccessExp5
    def eval(env = Environment.new)
      offsets = offset_specifier_exp.eval(env)
      ruby_array = array_literal.eval(env)
      left_associative_apply(ruby_array, offsets)
    end
  end

  def _nt_offset_access_exp
    start_index = index
    if node_cache[:offset_access_exp].has_key?(index)
      cached = node_cache[:offset_access_exp][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_variable
    s1 << r2
    if r2
      r3 = _nt_offset_specifier_exp
      s1 << r3
    end
    if s1.last
      r1 = (OffsetAccessExpression).new(input, i1...index, s1)
      r1.extend(OffsetAccessExp0)
      r1.extend(OffsetAccessExp1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i4, s4 = index, []
      r5 = _nt_pattern_match_exp
      s4 << r5
      if r5
        r6 = _nt_offset_specifier_exp
        s4 << r6
      end
      if s4.last
        r4 = (OffsetAccessExpression).new(input, i4...index, s4)
        r4.extend(OffsetAccessExp2)
        r4.extend(OffsetAccessExp3)
      else
        self.index = i4
        r4 = nil
      end
      if r4
        r0 = r4
      else
        i7, s7 = index, []
        r8 = _nt_array_literal
        s7 << r8
        if r8
          r9 = _nt_offset_specifier_exp
          s7 << r9
        end
        if s7.last
          r7 = (OffsetAccessExpression).new(input, i7...index, s7)
          r7.extend(OffsetAccessExp4)
          r7.extend(OffsetAccessExp5)
        else
          self.index = i7
          r7 = nil
        end
        if r7
          r0 = r7
        else
          self.index = i0
          r0 = nil
        end
      end
    end

    node_cache[:offset_access_exp][start_index] = r0

    return r0
  end

  module OffsetSpecifierExp0
    def expression
      elements[1]
    end

    def offset_specifier_exp
      elements[3]
    end
  end

  module OffsetSpecifierExp1
    def eval(env = Environment.new)
      [ expression.eval(env) ] + offset_specifier_exp.eval(env)
    end
  end

  module OffsetSpecifierExp2
    def expression
      elements[1]
    end

  end

  module OffsetSpecifierExp3
    def eval(env = Environment.new)
       [ expression.eval(env) ]
    end
  end

  def _nt_offset_specifier_exp
    start_index = index
    if node_cache[:offset_specifier_exp].has_key?(index)
      cached = node_cache[:offset_specifier_exp][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if input.index('[', index) == index
      r2 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('[')
      r2 = nil
    end
    s1 << r2
    if r2
      r3 = _nt_expression
      s1 << r3
      if r3
        if input.index(']', index) == index
          r4 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure(']')
          r4 = nil
        end
        s1 << r4
        if r4
          r5 = _nt_offset_specifier_exp
          s1 << r5
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(OffsetSpecifierExp0)
      r1.extend(OffsetSpecifierExp1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i6, s6 = index, []
      if input.index('[', index) == index
        r7 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure('[')
        r7 = nil
      end
      s6 << r7
      if r7
        r8 = _nt_expression
        s6 << r8
        if r8
          if input.index(']', index) == index
            r9 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure(']')
            r9 = nil
          end
          s6 << r9
        end
      end
      if s6.last
        r6 = (SyntaxNode).new(input, i6...index, s6)
        r6.extend(OffsetSpecifierExp2)
        r6.extend(OffsetSpecifierExp3)
      else
        self.index = i6
        r6 = nil
      end
      if r6
        r0 = r6
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:offset_specifier_exp][start_index] = r0

    return r0
  end

  def _nt_pattern_match_exp
    start_index = index
    if node_cache[:pattern_match_exp].has_key?(index)
      cached = node_cache[:pattern_match_exp][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_exact_match_exp
    if r1
      r0 = r1
    else
      r2 = _nt_regex_match_exp
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:pattern_match_exp][start_index] = r0

    return r0
  end

  module PatternMatchExp0
    def variable
      elements[0]
    end

  end

  module PatternMatchExp1
    def eval(env = Environment.new)
      match_op = elements[1].match_op
      pattern = elements[1].pattern(env)
      enumerable = variable.eval(env)
      if enumerable.is_a?(Array)
        enumerable.find_all { |e| e.send(match_op, pattern) }
      elsif enumerable.is_a?(Hash)
        enumerable.select { |k, v| v.send(match_op, pattern) }
      else
        msg = "Pattern matching is not possible for #{enumerable.class} (only Arrays and Hashes allowed)"
        raise Trxl::InvalidOperationException, msg
      end
    end
  end

  def _nt_pattern_match_exp
    start_index = index
    if node_cache[:pattern_match_exp].has_key?(index)
      cached = node_cache[:pattern_match_exp][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_variable
    s0 << r1
    if r1
      i2 = index
      r3 = _nt_exact_match_exp
      if r3
        r2 = r3
      else
        r4 = _nt_regex_match_exp
        if r4
          r2 = r4
        else
          self.index = i2
          r2 = nil
        end
      end
      s0 << r2
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(PatternMatchExp0)
      r0.extend(PatternMatchExp1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:pattern_match_exp][start_index] = r0

    return r0
  end

  module ExactMatchExp0
    def primary
      elements[1]
    end

  end

  module ExactMatchExp1
    def pattern(env = Environment.new)
      primary.eval(env)
    end

    def match_op
      '=='
    end
  end

  def _nt_exact_match_exp
    start_index = index
    if node_cache[:exact_match_exp].has_key?(index)
      cached = node_cache[:exact_match_exp][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('[=', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 2))
      @index += 2
    else
      terminal_parse_failure('[=')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_primary
      s0 << r2
      if r2
        if input.index(']', index) == index
          r3 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure(']')
          r3 = nil
        end
        s0 << r3
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(ExactMatchExp0)
      r0.extend(ExactMatchExp1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:exact_match_exp][start_index] = r0

    return r0
  end

  module RegexMatchExp0
    def regexp
      elements[1]
    end

  end

  module RegexMatchExp1
    def pattern(env = Environment.new)
      regexp.eval(env)
    end

    def match_op
      '=~'
    end
  end

  def _nt_regex_match_exp
    start_index = index
    if node_cache[:regex_match_exp].has_key?(index)
      cached = node_cache[:regex_match_exp][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('[', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('[')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_regexp
      s0 << r2
      if r2
        if input.index(']', index) == index
          r3 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure(']')
          r3 = nil
        end
        s0 << r3
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(RegexMatchExp0)
      r0.extend(RegexMatchExp1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:regex_match_exp][start_index] = r0

    return r0
  end

  module Regexp0
    def regexp_body
      elements[1]
    end

  end

  module Regexp1
    def eval(env = Environment.new)
      regexp_body.eval(env)
    end
  end

  def _nt_regexp
    start_index = index
    if node_cache[:regexp].has_key?(index)
      cached = node_cache[:regexp][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index("/", index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure("/")
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_regexp_body
      s0 << r2
      if r2
        if input.index("/", index) == index
          r3 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("/")
          r3 = nil
        end
        s0 << r3
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(Regexp0)
      r0.extend(Regexp1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:regexp][start_index] = r0

    return r0
  end

  module RegexpBody0
    def eval(env = Environment.new)
      text_value # allow anything for now
    end
  end

  def _nt_regexp_body
    start_index = index
    if node_cache[:regexp_body].has_key?(index)
      cached = node_cache[:regexp_body][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      if index < input_length
        r1 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("any character")
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    if s0.empty?
      self.index = i0
      r0 = nil
    else
      r0 = SyntaxNode.new(input, i0...index, s0)
      r0.extend(RegexpBody0)
    end

    node_cache[:regexp_body][start_index] = r0

    return r0
  end

  module Variable0
  end

  module Variable1

    def eval(env = Environment.new)
      if env.has_key?(name)
        env[name]
      else
        raise(Trxl::MissingVariableException, "variable #{name} is not defined")
      end
    end

    def bind(value, env)
      env.merge(text_value.to_sym => value)
    end

    def to_s(env = Environment.new)
      if env.has_key?(name)
        value = env[name]
        (value.is_a?(Array) || value.is_a?(Hash)) ? value.inspect : value.to_s
      else 
        text_value
      end
    end

    def name
      text_value.to_sym
    end
  end

  def _nt_variable
    start_index = index
    if node_cache[:variable].has_key?(index)
      cached = node_cache[:variable][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    s1, i1 = [], index
    loop do
      if input.index(Regexp.new('[a-zA-Z_]'), index) == index
        r2 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        r2 = nil
      end
      if r2
        s1 << r2
      else
        break
      end
    end
    if s1.empty?
      self.index = i1
      r1 = nil
    else
      r1 = SyntaxNode.new(input, i1...index, s1)
    end
    s0 << r1
    if r1
      s3, i3 = [], index
      loop do
        i4 = index
        if input.index(Regexp.new('[0-9]'), index) == index
          r5 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          r5 = nil
        end
        if r5
          r4 = r5
        else
          if input.index(Regexp.new('[a-zA-Z_]'), index) == index
            r6 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            r6 = nil
          end
          if r6
            r4 = r6
          else
            self.index = i4
            r4 = nil
          end
        end
        if r4
          s3 << r4
        else
          break
        end
      end
      r3 = SyntaxNode.new(input, i3...index, s3)
      s0 << r3
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(Variable0)
      r0.extend(Variable1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:variable][start_index] = r0

    return r0
  end

  module Number0
    def to_s(env = Environment.new)
      text_value
    end
  end

  def _nt_number
    start_index = index
    if node_cache[:number].has_key?(index)
      cached = node_cache[:number][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_real_number
    if r1
      r0 = r1
    else
      r2 = _nt_integer_number
      r2.extend(Number0)
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:number][start_index] = r0

    return r0
  end

  module IntegerNumber0
  end

  module IntegerNumber1
  end

  module IntegerNumber2
    def eval(env = Environment.new)
      text_value.to_i
    end
  end

  def _nt_integer_number
    start_index = index
    if node_cache[:integer_number].has_key?(index)
      cached = node_cache[:integer_number][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('-', index) == index
      r2 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('-')
      r2 = nil
    end
    if r2
      r1 = r2
    else
      r1 = SyntaxNode.new(input, index...index)
    end
    s0 << r1
    if r1
      i3 = index
      i4, s4 = index, []
      if input.index(Regexp.new('[1-9]'), index) == index
        r5 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        r5 = nil
      end
      s4 << r5
      if r5
        s6, i6 = [], index
        loop do
          if input.index(Regexp.new('[0-9]'), index) == index
            r7 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            r7 = nil
          end
          if r7
            s6 << r7
          else
            break
          end
        end
        r6 = SyntaxNode.new(input, i6...index, s6)
        s4 << r6
      end
      if s4.last
        r4 = (SyntaxNode).new(input, i4...index, s4)
        r4.extend(IntegerNumber0)
      else
        self.index = i4
        r4 = nil
      end
      if r4
        r3 = r4
      else
        if input.index('0', index) == index
          r8 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('0')
          r8 = nil
        end
        if r8
          r3 = r8
        else
          self.index = i3
          r3 = nil
        end
      end
      s0 << r3
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(IntegerNumber1)
      r0.extend(IntegerNumber2)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:integer_number][start_index] = r0

    return r0
  end

  module RealNumber0
  end

  module RealNumber1
    def eval(env = Environment.new)
      text_value.to_f
    end
  end

  def _nt_real_number
    start_index = index
    if node_cache[:real_number].has_key?(index)
      cached = node_cache[:real_number][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('-', index) == index
      r2 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('-')
      r2 = nil
    end
    if r2
      r1 = r2
    else
      r1 = SyntaxNode.new(input, index...index)
    end
    s0 << r1
    if r1
      s3, i3 = [], index
      loop do
        if input.index(Regexp.new('[0-9]'), index) == index
          r4 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          r4 = nil
        end
        if r4
          s3 << r4
        else
          break
        end
      end
      r3 = SyntaxNode.new(input, i3...index, s3)
      s0 << r3
      if r3
        if input.index('.', index) == index
          r5 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('.')
          r5 = nil
        end
        s0 << r5
        if r5
          s6, i6 = [], index
          loop do
            if input.index(Regexp.new('[0-9]'), index) == index
              r7 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              r7 = nil
            end
            if r7
              s6 << r7
            else
              break
            end
          end
          r6 = SyntaxNode.new(input, i6...index, s6)
          s0 << r6
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(RealNumber0)
      r0.extend(RealNumber1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:real_number][start_index] = r0

    return r0
  end

  def _nt_predefined_function
    start_index = index
    if node_cache[:predefined_function].has_key?(index)
      cached = node_cache[:predefined_function][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_help_function
    if r1
      r0 = r1
    else
      r2 = _nt_env_function
      if r2
        r0 = r2
      else
        r3 = _nt_print_line_function
        if r3
          r0 = r3
        else
          r4 = _nt_print_function
          if r4
            r0 = r4
          else
            r5 = _nt_size_function
            if r5
              r0 = r5
            else
              r6 = _nt_split_function
              if r6
                r0 = r6
              else
                r7 = _nt_to_int_function
                if r7
                  r0 = r7
                else
                  r8 = _nt_to_float_function
                  if r8
                    r0 = r8
                  else
                    r9 = _nt_to_array_function
                    if r9
                      r0 = r9
                    else
                      r10 = _nt_round_function
                      if r10
                        r0 = r10
                      else
                        r11 = _nt_min_function
                        if r11
                          r0 = r11
                        else
                          r12 = _nt_max_function
                          if r12
                            r0 = r12
                          else
                            r13 = _nt_sum_function
                            if r13
                              r0 = r13
                            else
                              r14 = _nt_mult_function
                              if r14
                                r0 = r14
                              else
                                r15 = _nt_avg_sum_function
                                if r15
                                  r0 = r15
                                else
                                  r16 = _nt_avg_function
                                  if r16
                                    r0 = r16
                                  else
                                    r17 = _nt_matching_ids_function
                                    if r17
                                      r0 = r17
                                    else
                                      r18 = _nt_values_of_type_function
                                      if r18
                                        r0 = r18
                                      else
                                        self.index = i0
                                        r0 = nil
                                      end
                                    end
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end

    node_cache[:predefined_function][start_index] = r0

    return r0
  end

  module HelpFunction0
    def eval(env = Environment.new)
      to_s(env)
    end
   
    def to_s(env = Environment.new)
      help =  "-----------------------------------------\n"
      help =  "           TRXL Language HELP            \n"
      help =  "-----------------------------------------\n"
      help << "1)  Built in operators:\n"
      help << "    +,-,*,/,%,==,!=,<=,>=,<,>,;\n"
      help << "-----------------------------------------\n"
      help << "2)  Integers and floats in arithmetics:\n"
      help << "    1 or 2.33333 or 0.34 or .34\n"
      help << "-----------------------------------------\n"
      help << "3)  Arbitrary nesting of parentheses:\n"
      help << "    (1+2*(5+((3+4)*3)-6/2)+7*2)\n"
      help << "    => 61\n"
      help << "-----------------------------------------\n"
      help << "4)  Comments:\n"
      help << "    # A comment until the end of the line\n"
      help << "    /* A longer comment that\n"
      help << "       spans multiple lines\n"
      help << "     */\n"
      help << "-----------------------------------------\n"
      help << "5)  Built in keywords:\n"
      help << "    TRUE,FALSE,NULL,IF,ELSE,END\n"
      help << "-----------------------------------------\n"
      help << "6)  Built in functions:\n"
      help << "    HELP,ENV,SIZE,SPLIT,ROUND,MIN,MAX\n"
      help << "    SUM,MULT,AVG, PRINT, PRINT_LINE\n"
      help << "    TO_INT, TO_FLOAT, TO_ARRAY\n"
      help << "-----------------------------------------\n"
      help << "7)  Standard library functions:\n"
      help << "    Use to iterate over Arrays or Strings\n"
      help << "    FOREACH_IN, INJECT\n"
      help << "-----------------------------------------\n"
      help << "8)  Access the current environment:\n"
      help << "    ENV; (your output may differ)\n"
      help << "    => { :a => 3, :foo => 5 }\n"
      help << "    Given the following environment:\n"
      help << "    { :a => 1, :b => 2, :c => 3 }\n"
      help << "    ENV['a']\n"
      help << "    => 1\n"
      help << "    ENV['a'..'b']\n"
      help << "    => { :a => 1, :b => 2 }\n"
      help << "-----------------------------------------\n"
      help << "9)  Numeric variables and literals\n"
      help << "    3;\n"
      help << "    => 3\n"
      help << "    a = 3;\n"
      help << "    => 3\n"
      help << "    a;\n"
      help << "    => 3\n"
      help << "-----------------------------------------\n"
      help << "10) String variables and literals\n"
      help << "    \"This is a string\";\n"
      help << "    => \"This is a string\";\n"
      help << "    'This is a string';\n"
      help << "    => \"This is a string\";\n"
      help << "    s1 = \"This is a string\"; s1;\n"
      help << "    => \"This is a string\"\n"
      help << "    s2 = 'This is a string'; s2;\n"
      help << "    => \"This is a string\"\n"
      help << "    SIZE(s1);\n"
      help << "    => 16\n"
      help << "    SIZE(\"foo\");\n"
      help << "    => 3\n"
      help << "-----------------------------------------\n"
      help << "11) Variables and closure applications\n"
      help << "    a = 3; foo = 5;\n"
      help << "    calc = fun(x,y) { (x + y) * a + foo };\n"
      help << "    calc(2,2);\n"
      help << "    => 17\n"
      help << "-----------------------------------------\n"
      help << "12) Array variables and literals\n"
      help << "    arr = [1, [fun(){2}()], fun(x){x}(3)]\n"
      help << "    SIZE(arr);\n"
      help << "    => 3\n"
      help << "    SIZE([1,2,3]);\n"
      help << "    => 3\n"
      help << "    [1,2,3] + [4,[5,6]];\n"
      help << "    => [1,2,3,4,[5,6]]\n"
      help << "    [1,2,3] - [[1],2,3];\n"
      help << "    => [1]\n"
      help << "-----------------------------------------\n"
      help << "13) Hash variables and literals\n"
      help << "    h = { 1 => fun(){2}(), 'a' => 'foo' }\n"
      help << "    SIZE(h);\n"
      help << "    => 2\n"
      help << "    h[1];\n"
      help << "    => 'fun(){2}()'\n"
      help << "    h['a'];\n"
      help << "    => 'foo'\n"
      help << "    SIZE({ 1 => 2});\n"
      help << "    => 1\n"
      help << "-----------------------------------------\n"
      help << "14) Range variables and literals\n"
      help << "    range_including_upper = 1..5\n" 
      help << "    => [ 1, 2, 3, 4, 5 ]\n" 
      help << "    SIZE(range_including_upper);\n"
      help << "    => 5\n"
      help << "    range_excluding_upper = 1...5\n"
      help << "    => [ 1, 2, 3, 4 ]\n" 
      help << "    SIZE(range_excluding_upper);\n"
      help << "    => 4\n"
      help << "    SIZE([1..5);\n"
      help << "    => 5\n"
      help << "-----------------------------------------\n"
      help << "15) Conditional branching and recursion:\n"
      help << "    factorial = fun(x) {\n"
      help << "      if(x == 0)\n" 
      help << "        1\n" 
      help << "      else\n"
      help << "        x * factorial(x - 1)\n"
      help << "      end\n"
      help << "    }\n"
      help << "    factorial(5);\n"
      help << "    => 120\n"
      help << "-----------------------------------------\n"
      help << "16) Conditional branching:\n"
      help << "    foo = fun(x) {\n"
      help << "      if(x == 0)\n" 
      help << "        0\n" 
      help << "      elsif(x == 1)\n"
      help << "        1\n"
      help << "      else\n"
      help << "        2\n"
      help << "      end\n"
      help << "    }\n"
      help << "    foo(0);\n"
      help << "    => 0\n"
      help << "    foo(1);\n"
      help << "    => 1\n"
      help << "    foo(2);\n"
      help << "    => 2\n"
      help << "-----------------------------------------\n"
      help << "17) case expressions:\n"
      help << "    foo = fun(x) {\n"
      help << "      case x\n" 
      help << "        when 0 then 0\n" 
      help << "        when 1 then 1\n" 
      help << "        when 2 then 2\n" 
      help << "        else 3\n"
      help << "      end\n"
      help << "    }\n"
      help << "    foo(1);\n"
      help << "    => 1\n"
      help << "    foo(3);\n"
      help << "    => 3\n"
      help << "-----------------------------------------\n"
      help
    end
  end

  def _nt_help_function
    start_index = index
    if node_cache[:help_function].has_key?(index)
      cached = node_cache[:help_function][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index('HELP', index) == index
      r0 = (SyntaxNode).new(input, index...(index + 4))
      r0.extend(HelpFunction0)
      @index += 4
    else
      terminal_parse_failure('HELP')
      r0 = nil
    end

    node_cache[:help_function][start_index] = r0

    return r0
  end

  module EnvFunction0
    def space
      elements[1]
    end

    def space
      elements[3]
    end

    def range_literal
      elements[4]
    end

    def space
      elements[5]
    end

  end

  module EnvFunction1
    def eval(env = Environment.new)
      if range_literal.range_type(env) == :string
        env_range = range_literal.eval(env)
        #Hash[*(env.select{ |k,v|  env_range.include?(k.to_s) }).flatten]
        env.select{ |k,v|  env_range.include?(k.to_s) }.map { |pair| pair[1] }
      else
        raise Trxl::InvalidOperationException, "ENV range not of type String"
      end
    end
  end

  module EnvFunction2
    def space
      elements[1]
    end

    def space
      elements[3]
    end

    def expression
      elements[4]
    end

    def space
      elements[5]
    end

  end

  module EnvFunction3
    def eval(env = Environment.new)
      env[expression.eval(env).to_sym]
    end
  end

  module EnvFunction4
    def eval(env = Environment.new)
      env
    end
  end

  def _nt_env_function
    start_index = index
    if node_cache[:env_function].has_key?(index)
      cached = node_cache[:env_function][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if input.index('ENV', index) == index
      r2 = (SyntaxNode).new(input, index...(index + 3))
      @index += 3
    else
      terminal_parse_failure('ENV')
      r2 = nil
    end
    s1 << r2
    if r2
      r3 = _nt_space
      s1 << r3
      if r3
        if input.index('[', index) == index
          r4 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('[')
          r4 = nil
        end
        s1 << r4
        if r4
          r5 = _nt_space
          s1 << r5
          if r5
            r6 = _nt_range_literal
            s1 << r6
            if r6
              r7 = _nt_space
              s1 << r7
              if r7
                if input.index(']', index) == index
                  r8 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure(']')
                  r8 = nil
                end
                s1 << r8
              end
            end
          end
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(EnvFunction0)
      r1.extend(EnvFunction1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i9, s9 = index, []
      if input.index('ENV', index) == index
        r10 = (SyntaxNode).new(input, index...(index + 3))
        @index += 3
      else
        terminal_parse_failure('ENV')
        r10 = nil
      end
      s9 << r10
      if r10
        r11 = _nt_space
        s9 << r11
        if r11
          if input.index('[', index) == index
            r12 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('[')
            r12 = nil
          end
          s9 << r12
          if r12
            r13 = _nt_space
            s9 << r13
            if r13
              r14 = _nt_expression
              s9 << r14
              if r14
                r15 = _nt_space
                s9 << r15
                if r15
                  if input.index(']', index) == index
                    r16 = (SyntaxNode).new(input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure(']')
                    r16 = nil
                  end
                  s9 << r16
                end
              end
            end
          end
        end
      end
      if s9.last
        r9 = (SyntaxNode).new(input, i9...index, s9)
        r9.extend(EnvFunction2)
        r9.extend(EnvFunction3)
      else
        self.index = i9
        r9 = nil
      end
      if r9
        r0 = r9
      else
        if input.index('ENV', index) == index
          r17 = (SyntaxNode).new(input, index...(index + 3))
          r17.extend(EnvFunction4)
          @index += 3
        else
          terminal_parse_failure('ENV')
          r17 = nil
        end
        if r17
          r0 = r17
        else
          self.index = i0
          r0 = nil
        end
      end
    end

    node_cache[:env_function][start_index] = r0

    return r0
  end

  module PrintLineFunction0
    def space
      elements[1]
    end

    def space
      elements[3]
    end

    def expression
      elements[4]
    end

    def space
      elements[5]
    end

  end

  module PrintLineFunction1
    def eval(env = Environment.new)
      result = expression.eval(env) 
      puts (result.is_a?(Array) || result.is_a?(Hash)) ? result.inspect : result.to_s
    end
  end

  module PrintLineFunction2
    def space
      elements[1]
    end

    def space
      elements[3]
    end

  end

  module PrintLineFunction3
    def eval(env = Environment.new)
      puts
    end
  end

  def _nt_print_line_function
    start_index = index
    if node_cache[:print_line_function].has_key?(index)
      cached = node_cache[:print_line_function][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if input.index('PRINT_LINE', index) == index
      r2 = (SyntaxNode).new(input, index...(index + 10))
      @index += 10
    else
      terminal_parse_failure('PRINT_LINE')
      r2 = nil
    end
    s1 << r2
    if r2
      r3 = _nt_space
      s1 << r3
      if r3
        if input.index('(', index) == index
          r4 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('(')
          r4 = nil
        end
        s1 << r4
        if r4
          r5 = _nt_space
          s1 << r5
          if r5
            r6 = _nt_expression
            s1 << r6
            if r6
              r7 = _nt_space
              s1 << r7
              if r7
                if input.index(')', index) == index
                  r8 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure(')')
                  r8 = nil
                end
                s1 << r8
              end
            end
          end
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(PrintLineFunction0)
      r1.extend(PrintLineFunction1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i9, s9 = index, []
      if input.index('PRINT_LINE', index) == index
        r10 = (SyntaxNode).new(input, index...(index + 10))
        @index += 10
      else
        terminal_parse_failure('PRINT_LINE')
        r10 = nil
      end
      s9 << r10
      if r10
        r11 = _nt_space
        s9 << r11
        if r11
          if input.index('(', index) == index
            r12 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('(')
            r12 = nil
          end
          s9 << r12
          if r12
            r13 = _nt_space
            s9 << r13
            if r13
              if input.index(')', index) == index
                r14 = (SyntaxNode).new(input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure(')')
                r14 = nil
              end
              s9 << r14
            end
          end
        end
      end
      if s9.last
        r9 = (SyntaxNode).new(input, i9...index, s9)
        r9.extend(PrintLineFunction2)
        r9.extend(PrintLineFunction3)
      else
        self.index = i9
        r9 = nil
      end
      if r9
        r0 = r9
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:print_line_function][start_index] = r0

    return r0
  end

  module PrintFunction0
    def space
      elements[1]
    end

    def space
      elements[3]
    end

    def expression
      elements[4]
    end

    def space
      elements[5]
    end

  end

  module PrintFunction1
    def eval(env = Environment.new)
      result = expression.eval(env) 
      print (result.is_a?(Array) || result.is_a?(Hash)) ? result.inspect : result.to_s
    end
  end

  def _nt_print_function
    start_index = index
    if node_cache[:print_function].has_key?(index)
      cached = node_cache[:print_function][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('PRINT', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 5))
      @index += 5
    else
      terminal_parse_failure('PRINT')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_space
      s0 << r2
      if r2
        if input.index('(', index) == index
          r3 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('(')
          r3 = nil
        end
        s0 << r3
        if r3
          r4 = _nt_space
          s0 << r4
          if r4
            r5 = _nt_expression
            s0 << r5
            if r5
              r6 = _nt_space
              s0 << r6
              if r6
                if input.index(')', index) == index
                  r7 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure(')')
                  r7 = nil
                end
                s0 << r7
              end
            end
          end
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(PrintFunction0)
      r0.extend(PrintFunction1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:print_function][start_index] = r0

    return r0
  end

  module SizeFunction0
    def space
      elements[1]
    end

    def space
      elements[3]
    end

    def expression
      elements[4]
    end

    def space
      elements[5]
    end

  end

  module SizeFunction1
    def eval(env = Environment.new)
      result = expression.eval(env)
      if result.respond_to?(:length)
        result.length
      else
        raise Trxl::InvalidOperationException, "Argument is not Enumerable"
      end
    end
  end

  def _nt_size_function
    start_index = index
    if node_cache[:size_function].has_key?(index)
      cached = node_cache[:size_function][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('SIZE', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 4))
      @index += 4
    else
      terminal_parse_failure('SIZE')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_space
      s0 << r2
      if r2
        if input.index('(', index) == index
          r3 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('(')
          r3 = nil
        end
        s0 << r3
        if r3
          r4 = _nt_space
          s0 << r4
          if r4
            r5 = _nt_expression
            s0 << r5
            if r5
              r6 = _nt_space
              s0 << r6
              if r6
                if input.index(')', index) == index
                  r7 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure(')')
                  r7 = nil
                end
                s0 << r7
              end
            end
          end
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(SizeFunction0)
      r0.extend(SizeFunction1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:size_function][start_index] = r0

    return r0
  end

  module SplitFunction0
    def space
      elements[1]
    end

    def space
      elements[3]
    end

    def split_string
      elements[4]
    end

    def space
      elements[5]
    end

    def space
      elements[7]
    end

    def split_char
      elements[8]
    end

    def space
      elements[9]
    end

  end

  module SplitFunction1
    def eval(env = Environment.new)
      string, char = split_string.eval(env), split_char.eval(env)
      if string.is_a?(String) && char.is_a?(String)
        string.split(char)
      else
        raise Trxl::InvalidArgumentException, "Both arguments must be of type String"
      end
    end
  end

  def _nt_split_function
    start_index = index
    if node_cache[:split_function].has_key?(index)
      cached = node_cache[:split_function][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('SPLIT', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 5))
      @index += 5
    else
      terminal_parse_failure('SPLIT')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_space
      s0 << r2
      if r2
        if input.index('(', index) == index
          r3 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('(')
          r3 = nil
        end
        s0 << r3
        if r3
          r4 = _nt_space
          s0 << r4
          if r4
            r5 = _nt_expression
            s0 << r5
            if r5
              r6 = _nt_space
              s0 << r6
              if r6
                if input.index(',', index) == index
                  r7 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure(',')
                  r7 = nil
                end
                s0 << r7
                if r7
                  r8 = _nt_space
                  s0 << r8
                  if r8
                    r9 = _nt_expression
                    s0 << r9
                    if r9
                      r10 = _nt_space
                      s0 << r10
                      if r10
                        if input.index(')', index) == index
                          r11 = (SyntaxNode).new(input, index...(index + 1))
                          @index += 1
                        else
                          terminal_parse_failure(')')
                          r11 = nil
                        end
                        s0 << r11
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(SplitFunction0)
      r0.extend(SplitFunction1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:split_function][start_index] = r0

    return r0
  end

  module ToIntFunction0
    def space
      elements[1]
    end

    def space
      elements[3]
    end

    def expression
      elements[4]
    end

    def space
      elements[5]
    end

  end

  module ToIntFunction1
    def eval(env = Environment.new)
      expression.eval(env).to_i
    end
  end

  def _nt_to_int_function
    start_index = index
    if node_cache[:to_int_function].has_key?(index)
      cached = node_cache[:to_int_function][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('TO_INT', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 6))
      @index += 6
    else
      terminal_parse_failure('TO_INT')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_space
      s0 << r2
      if r2
        if input.index('(', index) == index
          r3 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('(')
          r3 = nil
        end
        s0 << r3
        if r3
          r4 = _nt_space
          s0 << r4
          if r4
            r5 = _nt_expression
            s0 << r5
            if r5
              r6 = _nt_space
              s0 << r6
              if r6
                if input.index(')', index) == index
                  r7 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure(')')
                  r7 = nil
                end
                s0 << r7
              end
            end
          end
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(ToIntFunction0)
      r0.extend(ToIntFunction1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:to_int_function][start_index] = r0

    return r0
  end

  module ToFloatFunction0
    def space
      elements[1]
    end

    def space
      elements[3]
    end

    def expression
      elements[4]
    end

    def space
      elements[5]
    end

  end

  module ToFloatFunction1
    def eval(env = Environment.new)
      expression.eval(env).to_f
    end
  end

  def _nt_to_float_function
    start_index = index
    if node_cache[:to_float_function].has_key?(index)
      cached = node_cache[:to_float_function][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('TO_FLOAT', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 8))
      @index += 8
    else
      terminal_parse_failure('TO_FLOAT')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_space
      s0 << r2
      if r2
        if input.index('(', index) == index
          r3 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('(')
          r3 = nil
        end
        s0 << r3
        if r3
          r4 = _nt_space
          s0 << r4
          if r4
            r5 = _nt_expression
            s0 << r5
            if r5
              r6 = _nt_space
              s0 << r6
              if r6
                if input.index(')', index) == index
                  r7 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure(')')
                  r7 = nil
                end
                s0 << r7
              end
            end
          end
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(ToFloatFunction0)
      r0.extend(ToFloatFunction1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:to_float_function][start_index] = r0

    return r0
  end

  module ToArrayFunction0
    def space
      elements[1]
    end

    def space
      elements[3]
    end

    def expression
      elements[4]
    end

    def space
      elements[5]
    end

  end

  module ToArrayFunction1
    def eval(env = Environment.new)
      result = expression.eval(env)
      if result.is_a?(Array)
        result
      elsif result.is_a?(Hash)
        result.to_a
      else
        [ result ]
      end
    end
  end

  def _nt_to_array_function
    start_index = index
    if node_cache[:to_array_function].has_key?(index)
      cached = node_cache[:to_array_function][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('TO_ARRAY', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 8))
      @index += 8
    else
      terminal_parse_failure('TO_ARRAY')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_space
      s0 << r2
      if r2
        if input.index('(', index) == index
          r3 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('(')
          r3 = nil
        end
        s0 << r3
        if r3
          r4 = _nt_space
          s0 << r4
          if r4
            r5 = _nt_expression
            s0 << r5
            if r5
              r6 = _nt_space
              s0 << r6
              if r6
                if input.index(')', index) == index
                  r7 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure(')')
                  r7 = nil
                end
                s0 << r7
              end
            end
          end
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(ToArrayFunction0)
      r0.extend(ToArrayFunction1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:to_array_function][start_index] = r0

    return r0
  end

  module RoundFunction0
    def space
      elements[1]
    end

    def space
      elements[3]
    end

    def value
      elements[4]
    end

    def space
      elements[5]
    end

    def space
      elements[7]
    end

    def digits
      elements[8]
    end

    def space
      elements[9]
    end

  end

  module RoundFunction1
    def eval(env = Environment.new)
      if ((v = value.eval(env)) && !v.is_a?(TrueClass))
        format("%0.#{digits.eval(env)}f", v).to_f
      else
        nil
      end
    end
  end

  def _nt_round_function
    start_index = index
    if node_cache[:round_function].has_key?(index)
      cached = node_cache[:round_function][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('ROUND', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 5))
      @index += 5
    else
      terminal_parse_failure('ROUND')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_space
      s0 << r2
      if r2
        if input.index('(', index) == index
          r3 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('(')
          r3 = nil
        end
        s0 << r3
        if r3
          r4 = _nt_space
          s0 << r4
          if r4
            r5 = _nt_expression
            s0 << r5
            if r5
              r6 = _nt_space
              s0 << r6
              if r6
                if input.index(',', index) == index
                  r7 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure(',')
                  r7 = nil
                end
                s0 << r7
                if r7
                  r8 = _nt_space
                  s0 << r8
                  if r8
                    r9 = _nt_expression
                    s0 << r9
                    if r9
                      r10 = _nt_space
                      s0 << r10
                      if r10
                        if input.index(')', index) == index
                          r11 = (SyntaxNode).new(input, index...(index + 1))
                          @index += 1
                        else
                          terminal_parse_failure(')')
                          r11 = nil
                        end
                        s0 << r11
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(RoundFunction0)
      r0.extend(RoundFunction1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:round_function][start_index] = r0

    return r0
  end

  module SumFunction0
    def space
      elements[0]
    end

    def space
      elements[2]
    end

    def expression
      elements[3]
    end
  end

  module SumFunction1
    def space
      elements[1]
    end

    def space
      elements[3]
    end

    def expression
      elements[4]
    end

    def more_expressions
      elements[5]
    end

    def space
      elements[6]
    end

  end

  module SumFunction2
    def eval(env = Environment.new)
      evaluated_expressions(env).compact.inject(0) do |sum, val| 
        sum + if val.is_a?(Array)
          val.flatten.compact.inject(0) { |next_sum, v| next_sum + v }
        else
          val
        end 
      end
    end

    def evaluated_expressions(env = Environment.new)
      expressions.map { |e| e.eval(env) }
    end

    def expressions
      [ expression ] + more_expressions.elements.map { |e| e.expression }
    end
  end

  module SumFunction3
    def space
      elements[1]
    end

    def space
      elements[3]
    end

  end

  module SumFunction4
    def eval(env = Environment.new)
      0
    end
  end

  def _nt_sum_function
    start_index = index
    if node_cache[:sum_function].has_key?(index)
      cached = node_cache[:sum_function][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if input.index('SUM', index) == index
      r2 = (SyntaxNode).new(input, index...(index + 3))
      @index += 3
    else
      terminal_parse_failure('SUM')
      r2 = nil
    end
    s1 << r2
    if r2
      r3 = _nt_space
      s1 << r3
      if r3
        if input.index('(', index) == index
          r4 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('(')
          r4 = nil
        end
        s1 << r4
        if r4
          r5 = _nt_space
          s1 << r5
          if r5
            r6 = _nt_expression
            s1 << r6
            if r6
              s7, i7 = [], index
              loop do
                i8, s8 = index, []
                r9 = _nt_space
                s8 << r9
                if r9
                  if input.index(',', index) == index
                    r10 = (SyntaxNode).new(input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure(',')
                    r10 = nil
                  end
                  s8 << r10
                  if r10
                    r11 = _nt_space
                    s8 << r11
                    if r11
                      r12 = _nt_expression
                      s8 << r12
                    end
                  end
                end
                if s8.last
                  r8 = (SyntaxNode).new(input, i8...index, s8)
                  r8.extend(SumFunction0)
                else
                  self.index = i8
                  r8 = nil
                end
                if r8
                  s7 << r8
                else
                  break
                end
              end
              r7 = SyntaxNode.new(input, i7...index, s7)
              s1 << r7
              if r7
                r13 = _nt_space
                s1 << r13
                if r13
                  if input.index(')', index) == index
                    r14 = (SyntaxNode).new(input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure(')')
                    r14 = nil
                  end
                  s1 << r14
                end
              end
            end
          end
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(SumFunction1)
      r1.extend(SumFunction2)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i15, s15 = index, []
      if input.index('SUM', index) == index
        r16 = (SyntaxNode).new(input, index...(index + 3))
        @index += 3
      else
        terminal_parse_failure('SUM')
        r16 = nil
      end
      s15 << r16
      if r16
        r17 = _nt_space
        s15 << r17
        if r17
          if input.index('(', index) == index
            r18 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('(')
            r18 = nil
          end
          s15 << r18
          if r18
            r19 = _nt_space
            s15 << r19
            if r19
              if input.index(')', index) == index
                r20 = (SyntaxNode).new(input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure(')')
                r20 = nil
              end
              s15 << r20
            end
          end
        end
      end
      if s15.last
        r15 = (SyntaxNode).new(input, i15...index, s15)
        r15.extend(SumFunction3)
        r15.extend(SumFunction4)
      else
        self.index = i15
        r15 = nil
      end
      if r15
        r0 = r15
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:sum_function][start_index] = r0

    return r0
  end

  module MultFunction0
    def space
      elements[0]
    end

    def space
      elements[2]
    end

    def expression
      elements[3]
    end
  end

  module MultFunction1
    def space
      elements[1]
    end

    def space
      elements[3]
    end

    def expression
      elements[4]
    end

    def more_expressions
      elements[5]
    end

    def space
      elements[6]
    end

  end

  module MultFunction2
    def eval(env = Environment.new)
      values = evaluated_expressions(env).compact
      return 0 if values.size == 0
      values.inject(1) do |sum, val| 
        sum * if val.is_a?(Array)
          val.flatten.compact.inject(1) { |next_sum, v| next_sum * v }
        else
          val
        end 
      end
    end

    def evaluated_expressions(env = Environment.new)
      expressions.map { |e| e.eval(env) }
    end

    def expressions
      [ expression ] + more_expressions.elements.map { |e| e.expression }
    end
  end

  module MultFunction3
    def space
      elements[1]
    end

    def space
      elements[3]
    end

  end

  module MultFunction4
    def eval(env = Environment.new)
      0
    end
  end

  def _nt_mult_function
    start_index = index
    if node_cache[:mult_function].has_key?(index)
      cached = node_cache[:mult_function][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if input.index('MULT', index) == index
      r2 = (SyntaxNode).new(input, index...(index + 4))
      @index += 4
    else
      terminal_parse_failure('MULT')
      r2 = nil
    end
    s1 << r2
    if r2
      r3 = _nt_space
      s1 << r3
      if r3
        if input.index('(', index) == index
          r4 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('(')
          r4 = nil
        end
        s1 << r4
        if r4
          r5 = _nt_space
          s1 << r5
          if r5
            r6 = _nt_expression
            s1 << r6
            if r6
              s7, i7 = [], index
              loop do
                i8, s8 = index, []
                r9 = _nt_space
                s8 << r9
                if r9
                  if input.index(',', index) == index
                    r10 = (SyntaxNode).new(input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure(',')
                    r10 = nil
                  end
                  s8 << r10
                  if r10
                    r11 = _nt_space
                    s8 << r11
                    if r11
                      r12 = _nt_expression
                      s8 << r12
                    end
                  end
                end
                if s8.last
                  r8 = (SyntaxNode).new(input, i8...index, s8)
                  r8.extend(MultFunction0)
                else
                  self.index = i8
                  r8 = nil
                end
                if r8
                  s7 << r8
                else
                  break
                end
              end
              r7 = SyntaxNode.new(input, i7...index, s7)
              s1 << r7
              if r7
                r13 = _nt_space
                s1 << r13
                if r13
                  if input.index(')', index) == index
                    r14 = (SyntaxNode).new(input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure(')')
                    r14 = nil
                  end
                  s1 << r14
                end
              end
            end
          end
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(MultFunction1)
      r1.extend(MultFunction2)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i15, s15 = index, []
      if input.index('MULT', index) == index
        r16 = (SyntaxNode).new(input, index...(index + 4))
        @index += 4
      else
        terminal_parse_failure('MULT')
        r16 = nil
      end
      s15 << r16
      if r16
        r17 = _nt_space
        s15 << r17
        if r17
          if input.index('(', index) == index
            r18 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('(')
            r18 = nil
          end
          s15 << r18
          if r18
            r19 = _nt_space
            s15 << r19
            if r19
              if input.index(')', index) == index
                r20 = (SyntaxNode).new(input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure(')')
                r20 = nil
              end
              s15 << r20
            end
          end
        end
      end
      if s15.last
        r15 = (SyntaxNode).new(input, i15...index, s15)
        r15.extend(MultFunction3)
        r15.extend(MultFunction4)
      else
        self.index = i15
        r15 = nil
      end
      if r15
        r0 = r15
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:mult_function][start_index] = r0

    return r0
  end

  module AvgFunction0
    def space
      elements[0]
    end

    def space
      elements[2]
    end

    def expression
      elements[3]
    end
  end

  module AvgFunction1
    def space
      elements[1]
    end

    def space
      elements[3]
    end

    def expression
      elements[4]
    end

    def more_expressions
      elements[5]
    end

    def space
      elements[6]
    end

  end

  module AvgFunction2
    def eval(env = Environment.new)
      strict = true
      nr_of_vals = 0
      values = expressions
      strict_flag = values[0].eval(env)
      if strict_flag.is_a?(TrueClass) || strict_flag.is_a?(FalseClass)
        values.shift
        strict = strict_flag
      end

      # if all values are nil return nil
      values = values.map { |v| v.eval(env) }
      return nil if values.compact.size == 0

      s = values.inject(0) do |sum, next_val|
        sum + if next_val.is_a?(Array)
          next_val.flatten.inject(0) do |next_sum, val| 
            nr_of_vals += 1 if val && (strict || (!strict && val != 0))
            next_sum + (val || 0)
          end
        else
          nr_of_vals += 1 if next_val && (strict || (!strict && next_val != 0))
          next_val || 0
        end 
      end
      (s != 0 && nr_of_vals != 0) ? s.to_f / nr_of_vals : 0
    end

    def expressions
      [ expression ] + more_expressions.elements.map { |e| e.expression }
    end
  end

  module AvgFunction3
    def space
      elements[1]
    end

    def space
      elements[3]
    end

  end

  module AvgFunction4
    def eval(env = Environment.new)
      0
    end
  end

  def _nt_avg_function
    start_index = index
    if node_cache[:avg_function].has_key?(index)
      cached = node_cache[:avg_function][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if input.index('AVG', index) == index
      r2 = (SyntaxNode).new(input, index...(index + 3))
      @index += 3
    else
      terminal_parse_failure('AVG')
      r2 = nil
    end
    s1 << r2
    if r2
      r3 = _nt_space
      s1 << r3
      if r3
        if input.index('(', index) == index
          r4 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('(')
          r4 = nil
        end
        s1 << r4
        if r4
          r5 = _nt_space
          s1 << r5
          if r5
            r6 = _nt_expression
            s1 << r6
            if r6
              s7, i7 = [], index
              loop do
                i8, s8 = index, []
                r9 = _nt_space
                s8 << r9
                if r9
                  if input.index(',', index) == index
                    r10 = (SyntaxNode).new(input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure(',')
                    r10 = nil
                  end
                  s8 << r10
                  if r10
                    r11 = _nt_space
                    s8 << r11
                    if r11
                      r12 = _nt_expression
                      s8 << r12
                    end
                  end
                end
                if s8.last
                  r8 = (SyntaxNode).new(input, i8...index, s8)
                  r8.extend(AvgFunction0)
                else
                  self.index = i8
                  r8 = nil
                end
                if r8
                  s7 << r8
                else
                  break
                end
              end
              r7 = SyntaxNode.new(input, i7...index, s7)
              s1 << r7
              if r7
                r13 = _nt_space
                s1 << r13
                if r13
                  if input.index(')', index) == index
                    r14 = (SyntaxNode).new(input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure(')')
                    r14 = nil
                  end
                  s1 << r14
                end
              end
            end
          end
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(AvgFunction1)
      r1.extend(AvgFunction2)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i15, s15 = index, []
      if input.index('AVG', index) == index
        r16 = (SyntaxNode).new(input, index...(index + 3))
        @index += 3
      else
        terminal_parse_failure('AVG')
        r16 = nil
      end
      s15 << r16
      if r16
        r17 = _nt_space
        s15 << r17
        if r17
          if input.index('(', index) == index
            r18 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('(')
            r18 = nil
          end
          s15 << r18
          if r18
            r19 = _nt_space
            s15 << r19
            if r19
              if input.index(')', index) == index
                r20 = (SyntaxNode).new(input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure(')')
                r20 = nil
              end
              s15 << r20
            end
          end
        end
      end
      if s15.last
        r15 = (SyntaxNode).new(input, i15...index, s15)
        r15.extend(AvgFunction3)
        r15.extend(AvgFunction4)
      else
        self.index = i15
        r15 = nil
      end
      if r15
        r0 = r15
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:avg_function][start_index] = r0

    return r0
  end

  module AvgSumFunction0
    def space
      elements[0]
    end

    def space
      elements[2]
    end

    def expression
      elements[3]
    end
  end

  module AvgSumFunction1
    def space
      elements[1]
    end

    def space
      elements[3]
    end

    def expression
      elements[4]
    end

    def more_expressions
      elements[5]
    end

    def space
      elements[6]
    end

  end

  module AvgSumFunction2
    def eval(env = Environment.new)
      strict = true
      nr_of_vals = 0
      values = expressions
      strict_flag = values[0].eval(env)
      if strict_flag.is_a?(TrueClass) || strict_flag.is_a?(FalseClass)
        values.shift
        strict = strict_flag
      end
      values.inject(0) do |sum, e|
        next_val = e.eval(env)
        sum + if next_val.is_a?(Array)
          nr_of_vals = 0
          res = next_val.inject(0) do |next_sum, val|
            if val.is_a?(Array)
              next_sum + val.inject(0) { |s, v| s + (v || 0) } / val.compact.size
            else
              nr_of_vals += 1 if val && (strict || (!strict && val != 0))
              next_sum + (val || 0)
            end
          end 
          nr_of_vals != 0 ? res / nr_of_vals : res
        else
          next_val || 0
        end
      end
    end

    def expressions
      [ expression ] + more_expressions.elements.map { |e| e.expression }
    end
  end

  module AvgSumFunction3
    def space
      elements[1]
    end

    def space
      elements[3]
    end

  end

  module AvgSumFunction4
    def eval(env = Environment.new)
      0
    end
  end

  def _nt_avg_sum_function
    start_index = index
    if node_cache[:avg_sum_function].has_key?(index)
      cached = node_cache[:avg_sum_function][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if input.index('AVG_SUM', index) == index
      r2 = (SyntaxNode).new(input, index...(index + 7))
      @index += 7
    else
      terminal_parse_failure('AVG_SUM')
      r2 = nil
    end
    s1 << r2
    if r2
      r3 = _nt_space
      s1 << r3
      if r3
        if input.index('(', index) == index
          r4 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('(')
          r4 = nil
        end
        s1 << r4
        if r4
          r5 = _nt_space
          s1 << r5
          if r5
            r6 = _nt_expression
            s1 << r6
            if r6
              s7, i7 = [], index
              loop do
                i8, s8 = index, []
                r9 = _nt_space
                s8 << r9
                if r9
                  if input.index(',', index) == index
                    r10 = (SyntaxNode).new(input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure(',')
                    r10 = nil
                  end
                  s8 << r10
                  if r10
                    r11 = _nt_space
                    s8 << r11
                    if r11
                      r12 = _nt_expression
                      s8 << r12
                    end
                  end
                end
                if s8.last
                  r8 = (SyntaxNode).new(input, i8...index, s8)
                  r8.extend(AvgSumFunction0)
                else
                  self.index = i8
                  r8 = nil
                end
                if r8
                  s7 << r8
                else
                  break
                end
              end
              r7 = SyntaxNode.new(input, i7...index, s7)
              s1 << r7
              if r7
                r13 = _nt_space
                s1 << r13
                if r13
                  if input.index(')', index) == index
                    r14 = (SyntaxNode).new(input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure(')')
                    r14 = nil
                  end
                  s1 << r14
                end
              end
            end
          end
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(AvgSumFunction1)
      r1.extend(AvgSumFunction2)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i15, s15 = index, []
      if input.index('AVG_SUM', index) == index
        r16 = (SyntaxNode).new(input, index...(index + 7))
        @index += 7
      else
        terminal_parse_failure('AVG_SUM')
        r16 = nil
      end
      s15 << r16
      if r16
        r17 = _nt_space
        s15 << r17
        if r17
          if input.index('(', index) == index
            r18 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('(')
            r18 = nil
          end
          s15 << r18
          if r18
            r19 = _nt_space
            s15 << r19
            if r19
              if input.index(')', index) == index
                r20 = (SyntaxNode).new(input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure(')')
                r20 = nil
              end
              s15 << r20
            end
          end
        end
      end
      if s15.last
        r15 = (SyntaxNode).new(input, i15...index, s15)
        r15.extend(AvgSumFunction3)
        r15.extend(AvgSumFunction4)
      else
        self.index = i15
        r15 = nil
      end
      if r15
        r0 = r15
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:avg_sum_function][start_index] = r0

    return r0
  end

  module MinFunction0
    def space
      elements[0]
    end

    def space
      elements[2]
    end

    def expression
      elements[3]
    end
  end

  module MinFunction1
    def space
      elements[1]
    end

    def space
      elements[3]
    end

    def expression
      elements[4]
    end

    def more_expressions
      elements[5]
    end

    def space
      elements[6]
    end

  end

  module MinFunction2
    def eval(env = Environment.new)
      expressions.map { |e| e.eval(env) }.min
    end

    def expressions
      [ expression ] + more_expressions.elements.map { |e| e.expression }
    end
  end

  module MinFunction3
    def space
      elements[1]
    end

    def space
      elements[3]
    end

  end

  module MinFunction4
    def eval(env = Environment.new)
      0
    end
  end

  def _nt_min_function
    start_index = index
    if node_cache[:min_function].has_key?(index)
      cached = node_cache[:min_function][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if input.index('MIN', index) == index
      r2 = (SyntaxNode).new(input, index...(index + 3))
      @index += 3
    else
      terminal_parse_failure('MIN')
      r2 = nil
    end
    s1 << r2
    if r2
      r3 = _nt_space
      s1 << r3
      if r3
        if input.index('(', index) == index
          r4 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('(')
          r4 = nil
        end
        s1 << r4
        if r4
          r5 = _nt_space
          s1 << r5
          if r5
            r6 = _nt_expression
            s1 << r6
            if r6
              s7, i7 = [], index
              loop do
                i8, s8 = index, []
                r9 = _nt_space
                s8 << r9
                if r9
                  if input.index(',', index) == index
                    r10 = (SyntaxNode).new(input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure(',')
                    r10 = nil
                  end
                  s8 << r10
                  if r10
                    r11 = _nt_space
                    s8 << r11
                    if r11
                      r12 = _nt_expression
                      s8 << r12
                    end
                  end
                end
                if s8.last
                  r8 = (SyntaxNode).new(input, i8...index, s8)
                  r8.extend(MinFunction0)
                else
                  self.index = i8
                  r8 = nil
                end
                if r8
                  s7 << r8
                else
                  break
                end
              end
              r7 = SyntaxNode.new(input, i7...index, s7)
              s1 << r7
              if r7
                r13 = _nt_space
                s1 << r13
                if r13
                  if input.index(')', index) == index
                    r14 = (SyntaxNode).new(input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure(')')
                    r14 = nil
                  end
                  s1 << r14
                end
              end
            end
          end
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(MinFunction1)
      r1.extend(MinFunction2)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i15, s15 = index, []
      if input.index('MIN', index) == index
        r16 = (SyntaxNode).new(input, index...(index + 3))
        @index += 3
      else
        terminal_parse_failure('MIN')
        r16 = nil
      end
      s15 << r16
      if r16
        r17 = _nt_space
        s15 << r17
        if r17
          if input.index('(', index) == index
            r18 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('(')
            r18 = nil
          end
          s15 << r18
          if r18
            r19 = _nt_space
            s15 << r19
            if r19
              if input.index(')', index) == index
                r20 = (SyntaxNode).new(input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure(')')
                r20 = nil
              end
              s15 << r20
            end
          end
        end
      end
      if s15.last
        r15 = (SyntaxNode).new(input, i15...index, s15)
        r15.extend(MinFunction3)
        r15.extend(MinFunction4)
      else
        self.index = i15
        r15 = nil
      end
      if r15
        r0 = r15
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:min_function][start_index] = r0

    return r0
  end

  module MaxFunction0
    def space
      elements[0]
    end

    def space
      elements[2]
    end

    def expression
      elements[3]
    end
  end

  module MaxFunction1
    def space
      elements[1]
    end

    def space
      elements[3]
    end

    def expression
      elements[4]
    end

    def more_expressions
      elements[5]
    end

    def space
      elements[6]
    end

  end

  module MaxFunction2
    def eval(env = Environment.new)
      expressions.map { |e| e.eval(env) }.max
    end

    def expressions
      [ expression ] + more_expressions.elements.map { |e| e.expression }
    end
  end

  module MaxFunction3
    def space
      elements[1]
    end

    def space
      elements[3]
    end

  end

  module MaxFunction4
    def eval(env = Environment.new)
      0
    end
  end

  def _nt_max_function
    start_index = index
    if node_cache[:max_function].has_key?(index)
      cached = node_cache[:max_function][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if input.index('MAX', index) == index
      r2 = (SyntaxNode).new(input, index...(index + 3))
      @index += 3
    else
      terminal_parse_failure('MAX')
      r2 = nil
    end
    s1 << r2
    if r2
      r3 = _nt_space
      s1 << r3
      if r3
        if input.index('(', index) == index
          r4 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('(')
          r4 = nil
        end
        s1 << r4
        if r4
          r5 = _nt_space
          s1 << r5
          if r5
            r6 = _nt_expression
            s1 << r6
            if r6
              s7, i7 = [], index
              loop do
                i8, s8 = index, []
                r9 = _nt_space
                s8 << r9
                if r9
                  if input.index(',', index) == index
                    r10 = (SyntaxNode).new(input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure(',')
                    r10 = nil
                  end
                  s8 << r10
                  if r10
                    r11 = _nt_space
                    s8 << r11
                    if r11
                      r12 = _nt_expression
                      s8 << r12
                    end
                  end
                end
                if s8.last
                  r8 = (SyntaxNode).new(input, i8...index, s8)
                  r8.extend(MaxFunction0)
                else
                  self.index = i8
                  r8 = nil
                end
                if r8
                  s7 << r8
                else
                  break
                end
              end
              r7 = SyntaxNode.new(input, i7...index, s7)
              s1 << r7
              if r7
                r13 = _nt_space
                s1 << r13
                if r13
                  if input.index(')', index) == index
                    r14 = (SyntaxNode).new(input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure(')')
                    r14 = nil
                  end
                  s1 << r14
                end
              end
            end
          end
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(MaxFunction1)
      r1.extend(MaxFunction2)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i15, s15 = index, []
      if input.index('MAX', index) == index
        r16 = (SyntaxNode).new(input, index...(index + 3))
        @index += 3
      else
        terminal_parse_failure('MAX')
        r16 = nil
      end
      s15 << r16
      if r16
        r17 = _nt_space
        s15 << r17
        if r17
          if input.index('(', index) == index
            r18 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('(')
            r18 = nil
          end
          s15 << r18
          if r18
            r19 = _nt_space
            s15 << r19
            if r19
              if input.index(')', index) == index
                r20 = (SyntaxNode).new(input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure(')')
                r20 = nil
              end
              s15 << r20
            end
          end
        end
      end
      if s15.last
        r15 = (SyntaxNode).new(input, i15...index, s15)
        r15.extend(MaxFunction3)
        r15.extend(MaxFunction4)
      else
        self.index = i15
        r15 = nil
      end
      if r15
        r0 = r15
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:max_function][start_index] = r0

    return r0
  end

  module MatchingIdsFunction0
    def space
      elements[1]
    end

    def space
      elements[3]
    end

    def match_exp
      elements[4]
    end

    def space
      elements[5]
    end

    def space
      elements[7]
    end

    def hash
      elements[8]
    end

    def space
      elements[9]
    end

  end

  module MatchingIdsFunction1
    def eval(env = Environment.new)
      if(h = hash.eval(env)).is_a?(Hash)
        h.select { |k, v| v == match_exp.eval(env) }.map { |entry| entry[0]  }
      else
        []
      end
    end
  end

  module MatchingIdsFunction2
    def space
      elements[1]
    end

    def space
      elements[3]
    end

  end

  module MatchingIdsFunction3
    def eval(env = Environment.new)
      []
    end
  end

  def _nt_matching_ids_function
    start_index = index
    if node_cache[:matching_ids_function].has_key?(index)
      cached = node_cache[:matching_ids_function][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if input.index('MATCHING_IDS', index) == index
      r2 = (SyntaxNode).new(input, index...(index + 12))
      @index += 12
    else
      terminal_parse_failure('MATCHING_IDS')
      r2 = nil
    end
    s1 << r2
    if r2
      r3 = _nt_space
      s1 << r3
      if r3
        if input.index('(', index) == index
          r4 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('(')
          r4 = nil
        end
        s1 << r4
        if r4
          r5 = _nt_space
          s1 << r5
          if r5
            r6 = _nt_expression
            s1 << r6
            if r6
              r7 = _nt_space
              s1 << r7
              if r7
                if input.index(',', index) == index
                  r8 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure(',')
                  r8 = nil
                end
                s1 << r8
                if r8
                  r9 = _nt_space
                  s1 << r9
                  if r9
                    r10 = _nt_expression
                    s1 << r10
                    if r10
                      r11 = _nt_space
                      s1 << r11
                      if r11
                        if input.index(')', index) == index
                          r12 = (SyntaxNode).new(input, index...(index + 1))
                          @index += 1
                        else
                          terminal_parse_failure(')')
                          r12 = nil
                        end
                        s1 << r12
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(MatchingIdsFunction0)
      r1.extend(MatchingIdsFunction1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i13, s13 = index, []
      if input.index('MATCHING_IDS', index) == index
        r14 = (SyntaxNode).new(input, index...(index + 12))
        @index += 12
      else
        terminal_parse_failure('MATCHING_IDS')
        r14 = nil
      end
      s13 << r14
      if r14
        r15 = _nt_space
        s13 << r15
        if r15
          if input.index('(', index) == index
            r16 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('(')
            r16 = nil
          end
          s13 << r16
          if r16
            r17 = _nt_space
            s13 << r17
            if r17
              if input.index(')', index) == index
                r18 = (SyntaxNode).new(input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure(')')
                r18 = nil
              end
              s13 << r18
            end
          end
        end
      end
      if s13.last
        r13 = (SyntaxNode).new(input, i13...index, s13)
        r13.extend(MatchingIdsFunction2)
        r13.extend(MatchingIdsFunction3)
      else
        self.index = i13
        r13 = nil
      end
      if r13
        r0 = r13
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:matching_ids_function][start_index] = r0

    return r0
  end

  module ValuesOfTypeFunction0
    def space
      elements[1]
    end

    def space
      elements[3]
    end

    def match_exp
      elements[4]
    end

    def space
      elements[5]
    end

    def space
      elements[7]
    end

    def all_types
      elements[8]
    end

    def space
      elements[9]
    end

    def space
      elements[11]
    end

    def all_values
      elements[12]
    end

    def space
      elements[13]
    end

  end

  module ValuesOfTypeFunction1
    def eval(env = Environment.new)
      types = all_types.eval(env)
      if types.is_a?(Hash)
        values = all_values.eval(env)
        if values.is_a?(Hash)
          types.select { |k, v| v == match_exp.eval(env) }.map do |entry| 
            values[entry[0]]
          end
        else
          raise Trxl::InvalidArgumentException, "Third parameter must be a Hash"
        end
      else
        raise Trxl::InvalidArgumentException, "Second parameter must be a Hash"
      end
    end
  end

  module ValuesOfTypeFunction2
    def space
      elements[1]
    end

    def space
      elements[3]
    end

  end

  module ValuesOfTypeFunction3
    def eval(env = Environment.new)
      []
    end
  end

  def _nt_values_of_type_function
    start_index = index
    if node_cache[:values_of_type_function].has_key?(index)
      cached = node_cache[:values_of_type_function][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if input.index('VALUES_OF_TYPE', index) == index
      r2 = (SyntaxNode).new(input, index...(index + 14))
      @index += 14
    else
      terminal_parse_failure('VALUES_OF_TYPE')
      r2 = nil
    end
    s1 << r2
    if r2
      r3 = _nt_space
      s1 << r3
      if r3
        if input.index('(', index) == index
          r4 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('(')
          r4 = nil
        end
        s1 << r4
        if r4
          r5 = _nt_space
          s1 << r5
          if r5
            r6 = _nt_expression
            s1 << r6
            if r6
              r7 = _nt_space
              s1 << r7
              if r7
                if input.index(',', index) == index
                  r8 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure(',')
                  r8 = nil
                end
                s1 << r8
                if r8
                  r9 = _nt_space
                  s1 << r9
                  if r9
                    r10 = _nt_expression
                    s1 << r10
                    if r10
                      r11 = _nt_space
                      s1 << r11
                      if r11
                        if input.index(',', index) == index
                          r12 = (SyntaxNode).new(input, index...(index + 1))
                          @index += 1
                        else
                          terminal_parse_failure(',')
                          r12 = nil
                        end
                        s1 << r12
                        if r12
                          r13 = _nt_space
                          s1 << r13
                          if r13
                            r14 = _nt_expression
                            s1 << r14
                            if r14
                              r15 = _nt_space
                              s1 << r15
                              if r15
                                if input.index(')', index) == index
                                  r16 = (SyntaxNode).new(input, index...(index + 1))
                                  @index += 1
                                else
                                  terminal_parse_failure(')')
                                  r16 = nil
                                end
                                s1 << r16
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(ValuesOfTypeFunction0)
      r1.extend(ValuesOfTypeFunction1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i17, s17 = index, []
      if input.index('VALUES_OF_TYPE', index) == index
        r18 = (SyntaxNode).new(input, index...(index + 14))
        @index += 14
      else
        terminal_parse_failure('VALUES_OF_TYPE')
        r18 = nil
      end
      s17 << r18
      if r18
        r19 = _nt_space
        s17 << r19
        if r19
          if input.index('(', index) == index
            r20 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('(')
            r20 = nil
          end
          s17 << r20
          if r20
            r21 = _nt_space
            s17 << r21
            if r21
              if input.index(')', index) == index
                r22 = (SyntaxNode).new(input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure(')')
                r22 = nil
              end
              s17 << r22
            end
          end
        end
      end
      if s17.last
        r17 = (SyntaxNode).new(input, i17...index, s17)
        r17.extend(ValuesOfTypeFunction2)
        r17.extend(ValuesOfTypeFunction3)
      else
        self.index = i17
        r17 = nil
      end
      if r17
        r0 = r17
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:values_of_type_function][start_index] = r0

    return r0
  end

  module NonSpaceChar0
  end

  def _nt_non_space_char
    start_index = index
    if node_cache[:non_space_char].has_key?(index)
      cached = node_cache[:non_space_char][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    i1 = index
    r2 = _nt_white
    if r2
      r1 = nil
    else
      self.index = i1
      r1 = SyntaxNode.new(input, index...index)
    end
    s0 << r1
    if r1
      if index < input_length
        r3 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("any character")
        r3 = nil
      end
      s0 << r3
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(NonSpaceChar0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:non_space_char][start_index] = r0

    return r0
  end

  module RequireKeyword0
  end

  def _nt_require_keyword
    start_index = index
    if node_cache[:require_keyword].has_key?(index)
      cached = node_cache[:require_keyword][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('require', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 7))
      @index += 7
    else
      terminal_parse_failure('require')
      r1 = nil
    end
    s0 << r1
    if r1
      i2 = index
      r3 = _nt_non_space_char
      if r3
        r2 = nil
      else
        self.index = i2
        r2 = SyntaxNode.new(input, index...index)
      end
      s0 << r2
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(RequireKeyword0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:require_keyword][start_index] = r0

    return r0
  end

  module CaseKeyword0
  end

  def _nt_case_keyword
    start_index = index
    if node_cache[:case_keyword].has_key?(index)
      cached = node_cache[:case_keyword][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('case', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 4))
      @index += 4
    else
      terminal_parse_failure('case')
      r1 = nil
    end
    s0 << r1
    if r1
      i2 = index
      r3 = _nt_non_space_char
      if r3
        r2 = nil
      else
        self.index = i2
        r2 = SyntaxNode.new(input, index...index)
      end
      s0 << r2
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(CaseKeyword0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:case_keyword][start_index] = r0

    return r0
  end

  module WhenKeyword0
  end

  def _nt_when_keyword
    start_index = index
    if node_cache[:when_keyword].has_key?(index)
      cached = node_cache[:when_keyword][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('when', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 4))
      @index += 4
    else
      terminal_parse_failure('when')
      r1 = nil
    end
    s0 << r1
    if r1
      i2 = index
      r3 = _nt_non_space_char
      if r3
        r2 = nil
      else
        self.index = i2
        r2 = SyntaxNode.new(input, index...index)
      end
      s0 << r2
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(WhenKeyword0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:when_keyword][start_index] = r0

    return r0
  end

  module ThenKeyword0
  end

  def _nt_then_keyword
    start_index = index
    if node_cache[:then_keyword].has_key?(index)
      cached = node_cache[:then_keyword][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('then', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 4))
      @index += 4
    else
      terminal_parse_failure('then')
      r1 = nil
    end
    s0 << r1
    if r1
      i2 = index
      r3 = _nt_non_space_char
      if r3
        r2 = nil
      else
        self.index = i2
        r2 = SyntaxNode.new(input, index...index)
      end
      s0 << r2
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(ThenKeyword0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:then_keyword][start_index] = r0

    return r0
  end

  module IfKeyword0
  end

  def _nt_if_keyword
    start_index = index
    if node_cache[:if_keyword].has_key?(index)
      cached = node_cache[:if_keyword][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('if', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 2))
      @index += 2
    else
      terminal_parse_failure('if')
      r1 = nil
    end
    s0 << r1
    if r1
      i2 = index
      i3 = index
      if input.index('(', index) == index
        r4 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure('(')
        r4 = nil
      end
      if r4
        r3 = r4
      else
        r5 = _nt_SPACE
        if r5
          r3 = r5
        else
          self.index = i3
          r3 = nil
        end
      end
      if r3
        self.index = i2
        r2 = SyntaxNode.new(input, index...index)
      else
        r2 = nil
      end
      s0 << r2
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(IfKeyword0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:if_keyword][start_index] = r0

    return r0
  end

  module ElseKeyword0
    def SPACE
      elements[1]
    end
  end

  def _nt_else_keyword
    start_index = index
    if node_cache[:else_keyword].has_key?(index)
      cached = node_cache[:else_keyword][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('else', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 4))
      @index += 4
    else
      terminal_parse_failure('else')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_SPACE
      s0 << r2
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(ElseKeyword0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:else_keyword][start_index] = r0

    return r0
  end

  module EndKeyword0
  end

  def _nt_end_keyword
    start_index = index
    if node_cache[:end_keyword].has_key?(index)
      cached = node_cache[:end_keyword][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('end', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 3))
      @index += 3
    else
      terminal_parse_failure('end')
      r1 = nil
    end
    s0 << r1
    if r1
      i2 = index
      i3 = index
      if input.index(';', index) == index
        r4 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure(';')
        r4 = nil
      end
      if r4
        r3 = r4
      else
        if input.index('}', index) == index
          r5 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('}')
          r5 = nil
        end
        if r5
          r3 = r5
        else
          r6 = _nt_space
          if r6
            r3 = r6
          else
            self.index = i3
            r3 = nil
          end
        end
      end
      if r3
        self.index = i2
        r2 = SyntaxNode.new(input, index...index)
      else
        r2 = nil
      end
      s0 << r2
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(EndKeyword0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:end_keyword][start_index] = r0

    return r0
  end

  def _nt_comment
    start_index = index
    if node_cache[:comment].has_key?(index)
      cached = node_cache[:comment][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_comment_to_eol
    if r1
      r0 = r1
    else
      r2 = _nt_multiline_comment
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:comment][start_index] = r0

    return r0
  end

  module MultilineComment0
  end

  module MultilineComment1
  end

  def _nt_multiline_comment
    start_index = index
    if node_cache[:multiline_comment].has_key?(index)
      cached = node_cache[:multiline_comment][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('/*', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 2))
      @index += 2
    else
      terminal_parse_failure('/*')
      r1 = nil
    end
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        i3, s3 = index, []
        i4 = index
        if input.index('*/', index) == index
          r5 = (SyntaxNode).new(input, index...(index + 2))
          @index += 2
        else
          terminal_parse_failure('*/')
          r5 = nil
        end
        if r5
          r4 = nil
        else
          self.index = i4
          r4 = SyntaxNode.new(input, index...index)
        end
        s3 << r4
        if r4
          if index < input_length
            r6 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure("any character")
            r6 = nil
          end
          s3 << r6
        end
        if s3.last
          r3 = (SyntaxNode).new(input, i3...index, s3)
          r3.extend(MultilineComment0)
        else
          self.index = i3
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = SyntaxNode.new(input, i2...index, s2)
      s0 << r2
      if r2
        if input.index('*/', index) == index
          r7 = (SyntaxNode).new(input, index...(index + 2))
          @index += 2
        else
          terminal_parse_failure('*/')
          r7 = nil
        end
        s0 << r7
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(MultilineComment1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:multiline_comment][start_index] = r0

    return r0
  end

  module CommentToEol0
  end

  module CommentToEol1
  end

  def _nt_comment_to_eol
    start_index = index
    if node_cache[:comment_to_eol].has_key?(index)
      cached = node_cache[:comment_to_eol][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('#', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('#')
      r1 = nil
    end
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        i3, s3 = index, []
        i4 = index
        if input.index("\n", index) == index
          r5 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("\n")
          r5 = nil
        end
        if r5
          r4 = nil
        else
          self.index = i4
          r4 = SyntaxNode.new(input, index...index)
        end
        s3 << r4
        if r4
          if index < input_length
            r6 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure("any character")
            r6 = nil
          end
          s3 << r6
        end
        if s3.last
          r3 = (SyntaxNode).new(input, i3...index, s3)
          r3.extend(CommentToEol0)
        else
          self.index = i3
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = SyntaxNode.new(input, i2...index, s2)
      s0 << r2
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(CommentToEol1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:comment_to_eol][start_index] = r0

    return r0
  end

  def _nt_white
    start_index = index
    if node_cache[:white].has_key?(index)
      cached = node_cache[:white][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      if input.index(Regexp.new('[ \\r\\t\\n]'), index) == index
        r1 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    if s0.empty?
      self.index = i0
      r0 = nil
    else
      r0 = SyntaxNode.new(input, i0...index, s0)
    end

    node_cache[:white][start_index] = r0

    return r0
  end

  def _nt_SPACE
    start_index = index
    if node_cache[:SPACE].has_key?(index)
      cached = node_cache[:SPACE][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      i1 = index
      r2 = _nt_white
      if r2
        r1 = r2
      else
        r3 = _nt_comment
        if r3
          r1 = r3
        else
          self.index = i1
          r1 = nil
        end
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    if s0.empty?
      self.index = i0
      r0 = nil
    else
      r0 = SyntaxNode.new(input, i0...index, s0)
    end

    node_cache[:SPACE][start_index] = r0

    return r0
  end

  def _nt_space
    start_index = index
    if node_cache[:space].has_key?(index)
      cached = node_cache[:space][index]
      @index = cached.interval.end if cached
      return cached
    end

    r1 = _nt_SPACE
    if r1
      r0 = r1
    else
      r0 = SyntaxNode.new(input, index...index)
    end

    node_cache[:space][start_index] = r0

    return r0
  end

end

class TrxlParser < Treetop::Runtime::CompiledParser
  include Trxl
end
