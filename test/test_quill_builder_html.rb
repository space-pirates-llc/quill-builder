require 'helper'
require 'quill/builder/html'

class Quill::Builder::HTML::Test < Test::Unit::TestCase
  def test_convert_text
    input = {
      ops: [
        { insert: "aaa\n" },
      ]
    }
    output = Quill::Builder::HTML.new(input.to_json).convert_to_lines
    expect = [
      { block: :p, inlines: [ { attrs: [], text: "aaa\n" } ] }
    ]
    assert_equal(expect, output)
  end

  def test_convert_text_with_newline
    input = {
      ops: [
        { insert: "aaa\nbbb\n" },
      ]
    }
    output = Quill::Builder::HTML.new(input.to_json).convert_to_lines
    expect = [
      { block: :p, inlines: [ { attrs: [], text: "aaa\n" } ] },
      { block: :p, inlines: [ { attrs: [], text: "bbb\n" } ] }
    ]
    assert_equal(expect, output)
  end

  def test_convert_inline
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
          { attrs: [], text: "a\n" }
        ]
      }
    ]
    assert_equal(expect, output)
  end

  def test_convert_inline_with_multi_attrs
    input = {
      ops: [
        { insert: 'a' },
        {
          attributes: { bold: true, italic: true },
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
          { attrs: [['<b>', '</b>'], ['<i>', '</i>']], text: 'aaaa' },
          { attrs: [], text: "a\n" }
        ]
      }
    ]
    assert_equal(expect, output)
  end

  def test_convert_block
    input = {
      ops: [
        { insert: 'a' },
        {
          attributes: { bold: true },
          insert: 'aaaa'
        },
        { insert: 'a' },
        {
          attributes: { blockquote: true },
          insert: "\n"
        }
      ]
    }
    output = Quill::Builder::HTML.new(input.to_json).convert_to_lines
    expect = [
      {
        block: [ :p, :blockquote ],
        inlines: [
          { attrs: [], text: 'a' },
          { attrs: [['<b>', '</b>']], text: 'aaaa' },
          { attrs: [], text: 'a' }
        ]
      }
    ]
    assert_equal(expect, output)
  end

  def test_convert_block_with_next_text
    input = {
      ops: [
        { insert: 'a' },
        {
          attributes: { blockquote: true },
          insert: "\n"
        },
        { insert: 'b' }
      ]
    }
    output = Quill::Builder::HTML.new(input.to_json).convert_to_lines
    expect = [
      {
        block: [ :p, :blockquote ],
        inlines: [ { attrs: [], text: 'a' } ]
      },
      {
        block: :p,
        inlines: [ { attrs: [], text: 'b' } ]
      }
    ]
    assert_equal(expect, output)
  end

  def test_convert_block_with_prev_text
    input = {
      ops: [
        { insert: "a\nb" },
        {
          attributes: { blockquote: true },
          insert: "\n"
        }
      ]
    }
    output = Quill::Builder::HTML.new(input.to_json).convert_to_lines
    expect = [
      {
        block: :p,
        inlines: [ { attrs: [], text: "a\n" } ]
      },
      {
        block: [ :p, :blockquote ],
        inlines: [ { attrs: [], text: 'b' } ]
      }
    ]
    assert_equal(expect, output)
  end

  def test_convert_block_with_next_inline
    input = {
      ops: [
        { insert: 'a' },
        {
          attributes: { blockquote: true },
          insert: "\n"
        },
        {
          attributes: { bold: true },
          insert: 'b'
        },
        { insert: "\n"}
      ]
    }
    output = Quill::Builder::HTML.new(input.to_json).convert_to_lines
    expect = [
      {
        block: [ :p, :blockquote ],
        inlines: [ { attrs: [], text: 'a' } ]
      },
      {
        block: :p,
        inlines: [ { attrs: [['<b>', '</b>']], text: 'b' } ]
      }
    ]
    assert_equal(expect, output)
  end

  def test_convert_complex
    input = {
      ops: [
        { insert: "a"},
        { attributes: { blockquote: true }, insert: "\n" },
        { attributes: { bold: true }, insert: 'b' },
        { insert: "\n\n\n" },
        { attributes: { bold: true }, insert: 'a' },
        { insert: "\n" }
      ]
    }
    output = Quill::Builder::HTML.new(input.to_json).convert_to_lines
    expect = [
      {
        block: [ :p, :blockquote ],
        inlines: [
          { text: 'a', attrs: [] }
        ]
      },
      {
        block: :p,
        inlines: [
          { text: 'b', attrs: [['<b>', '</b>']] },
          { text: "\n", attrs: [] }
        ]
      },
      {
        block: :p,
        inlines: [
          { text: "\n", attrs: [] }
        ]
      },
      {
        block: :p,
        inlines: [
          { text: "\n", attrs: [] }
        ]
      },
      {
        block: :p,
        inlines: [
          { text: "a", attrs: [["<b>", "</b>"]] }
        ]
      }
    ]
    assert_equal(expect, output)
  end
end
