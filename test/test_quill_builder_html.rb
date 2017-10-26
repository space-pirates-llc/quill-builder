require 'helper'
require 'quill/builder/html'

class Quill::Builder::HTML::Test < Test::Unit::TestCase
  def test_convert_text_only
    input = {
      ops: [
        { insert: "aaa\nbbb\n" },
      ]
    }
    output = Quill::Builder::HTML.new(input.to_json).convert_intermediate
    expect = [
      { attrs: [], text: "aaa\nbbb\n" }
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
    output = Quill::Builder::HTML.new(input.to_json).convert_intermediate
    expect = [
      { text: 'a', attrs: [] },
      { text: 'aaaa', attrs: [["<b>", "</b>"]] },
      { text: "a\n", attrs: [] }
    ]
    assert_equal(expect, output)
  end
end
