require 'quill/builder/base'
require 'json'

module Quill::Builder
  class HTML < Base
    def initialize(text)
      @text = text
    end

    def convert
      tags = convert_to_lines
      tags.map { |item|
        text = item[:text].gsub("\n", '<br />')
        item[:attrs].inject(text) do |memo, tag_pair|
          "#{tag_pair.first}#{memo}#{tag_pair.last}"
        end
      }.join
    end

    def convert_to_lines
      json = JSON.parse(@text)
      lines = json['ops'].inject([{ block: :p, inlines: [] }]) do |lines, item|
        if item['attributes']&.keys&.include?('blockquote')
          lines.last[:block] = :blockquote
        elsif item['attributes']&.keys&.include?('code-block')
          lines.last[:block] = :pre
        else
          converted = convert_inline(item['insert'], item['attributes'])
          partition_item_to_each_lines(lines, converted)
        end
        lines
      end
      lines.pop if lines.last[:inlines].nil? || lines.last[:inlines].empty?
      lines
    end

    def partition_item_to_each_lines(lines, converted)
      if converted[:text].include?("\n")
        splitted = converted[:text].split("\n")
        lines.last[:inlines] << {
          text: splitted.shift,
          attrs: converted[:attrs]
        }
        lines << { block: :p, inlines: [] }
        splitted.each do |l|
          lines.last[:inlines] << {
            text: l,
            attrs: converted[:attrs]
          }
          lines << { block: :p, inlines: [] }
        end
      else
        lines.last[:inlines] << converted
      end
    end

    def convert_inline(text, attributes)
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
