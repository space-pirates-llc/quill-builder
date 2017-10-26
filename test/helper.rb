require 'test-unit'
require 'json'

# { "ops": [
#   { "insert": "あいうえお\n\n" },
#   { "attributes": { "bold": true }, "insert":"あ" },
#   { "attributes": { "italic": true, "bold": true }, "insert": "い" },
#   { "insert": "うえお\n" }
# ]}
{
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

