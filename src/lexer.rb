# -*- encoding: utf-8 -*-

class Lexer
  # Special Keyworkを定数で定義。
  # 識別子(メソッド名, ローカル変数など)と区別するため
  KEYWORDS = ["def", "class", "if", "true", "false", "nil"]

  def tokenize(code)
    code.chomp!
    tokens = []

    # インデントレベルを管理するための整数とスタック
    current_indent = 0
    indent_stack = []

    # 現在の読み進めている文字の位置
    # 正規表現を使ってコードを読み進める
    i = 0
    while i < code.size
      chunk = code[i..-1]

      # Special Keywordをチェックする。
      if identifier = chunk[/\A([a-z]\w*)/, 1]
        if KEYWORDS.include?(identifier)
          # keywords will generate [:IF, "if"]
          tokens << [identifier.upcase.to_sym, identifier]
        else
          tokens << [:IDENTIFIER, identifier]
        end
        # Special Keyword 分skip する。
        i += identifier.size
      # 大文字から始まる文字列はクラスの名前になる。
      elsif constant = chunk[/\A([A-Z]\w*)/, 1]
        tokens << [:CONSTANT, constant]
        i += consntant.size
      # 整数のチェック
      elsif number = chunk[/\A([0-9]+)/, 1]
        tokens << [:NUMBER, number.to_i]
        i += number.size
      # 文字列の取り出し
      elsif string = chunk[/\A"([^"]*)"/, 1]
        tokens << [:STRING, string]
        # +2 は、ダブルクォートの分
        i += string.size + 2
      elsif indent = chunk[/\A\:\n( +)/m, 1]
        if indent.size <= current_indent
          raise "Bad indent level, got #{indent.size} idents, " +
            "expected > #{current_indent}"
        end
        # インデントのスペースのサイズをスタックに貯める
        current_indent = indent.size
        indent_stack.push(current_indent)
        tokens << [:INDENT, indent.size]
        # :\n の分
        i += indent.size + 2
      elsif indent = chunk[/\A\n( *)/m, 1]
        if indent.size == current_indent
          tokens << [:NEWLINE, "\n"]
        elsif indent.size < current_indent
          while indent.size < current_indent
            indent_stack.pop
            current_indent = indent_stack.last || 0
            tokens << [:DEDENT, indent.size]
          end
          tokens << [:NEWLINE, "\n"]
        else
          raise "Missing ':'"
        end
        i += indent.size + 1
      elsif operator = chunk[/\A(\|\||&&|==|!=|<=|>=)/, 1]
        tokens << [operator, operator]
        i += operator.size
      elsif chunk.match(/\A /)
        i += 1
      else
        value = chunk[0, 1]
        tokens << [value, value]
        i += 1
      end
    end
    while indent = indent_stack.pop
      tokens << [:DEDENT, indent_stack.first || 0]
    end
    tokens
  end
end

