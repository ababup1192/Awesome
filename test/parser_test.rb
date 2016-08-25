# -*- encoding: utf-8 -*-

require 'test/unit'
require_relative '../src/parser.rb'

class LexerTest < Test::Unit::TestCase
  def test_parse
    code = <<-CODE
def method(a, b):
  true
CODE
    nodes = Nodes.new([
      DefNode.new("method", ["a", "b"],
                  Nodes.new([TrueNode.new])
                 )
    ])
    assert_equal nodes, Parser.new.parse(code)
  end
end
