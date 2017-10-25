require 'quill/builder/base'
require 'json'

module Quill::Builder
  class HTML < Base
    def initialize(text)
      @text = text
    end

    def convert
      tags = convert_intermediate
      tags.map { |item|
        text = item[:text].gsub("\n", '<br />')
        item[:attrs].inject(text) do |memo, tag_pair|
          "#{tag_pair.first}#{memo}#{tag_pair.last}"
        end
      }.join
    end

    def convert_intermediate
      json = JSON.parse(@text)
      tags = json['ops'].inject([]) do |memo, item|
        memo << convert_item(memo, item['insert'], item['attributes'])
      end
      tags
    end

    def convert_item(memo, text, attributes)
      attrs = []
      if attributes
        attributes.each_pair do |key, value|
          case key
          when 'bold'
            attrs << ['<b>', '</b>']
          when 'italic'
            attrs << ['<i>', '</i>']
          when 'underline'
            attrs << ['<u>', '</u>']
          when 'strike'
            attrs << ['<s>', '</s>']
          when 'background'
            attrs << [%Q|<span style="background-color: #{value}">|, '</span>']
          when 'color'
            attrs << [%Q|<span style="color: #{value}">|, '</span>']
          when 'blockquote'
            text = normalize_block(memo, text)
            attrs << ['<blockquote>', '</blockquote>']
          when 'code-block'
            text = normalize_block(memo, text)
            attrs << ['<pre>', '</pre>']
          end
        end
      end
      {
        text: text,
        attrs: attrs
      }
    end

    def normalize_block(memo, text)
      last = memo.last
      if last && text[0] == "\n" && last[:text][-1] != "\n"
        splited = last[:text].split(/(?<=\n)/)
        last[:text] = splited[0..-2].join("\n")
        text = splited.last + text[1..-1]
        memo.pop if last[:text].empty?
      end
      text
    end
  end
end
