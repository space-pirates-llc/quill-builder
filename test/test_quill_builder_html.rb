require 'helper'
require 'quill/builder/html'

class Quill::Builder::HTML::Test < Test::Unit::TestCase
  def test_convert_text_only
    input = {
      ops: [
        { insert: "aaa\n" },
      ]
    }
    output = Quill::Builder::HTML.new(input.to_json).convert_to_lines
    expect = [
      { block: :p, inlines: [ { attrs: [], text: 'aaa' } ] }
    ]
    assert_equal(expect, output)
  end

  def test_convert_text_only_with_newline
    input = {
      ops: [
        { insert: "aaa\nbbb\n" },
      ]
    }
    output = Quill::Builder::HTML.new(input.to_json).convert_to_lines
    expect = [
      { block: :p, inlines: [ { attrs: [], text: 'aaa' } ] },
      { block: :p, inlines: [ { attrs: [], text: 'bbb' } ] }
    ]
    assert_equal(expect, output)
  end

  def test_convert_inline_only
    input = {
      ops: [
        { insert: 'a' },
        {
          attributes: { bold: true },
          insert: 'aaaa'
        },
        { insert: "a\n" }
      ]
    }
    output = Quill::Builder::HTML.new(input.to_json).convert_to_lines
    expect = [
      {
        block: :p,
        inlines: [
          { attrs: [], text: 'a' },
          { attrs: [['<b>', '</b>']], text: 'aaaa' },
          { attrs: [], text: 'a' }
        ]
      }
    ]
    assert_equal(expect, output)
  end
end
