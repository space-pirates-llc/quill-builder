require 'quill/builder/base'
require 'json'

module Quill::Builder
  class HTML < Base
    def initialize(text)
      @text = text
    end

    def convert
      json = JSON.parse(@text)
      tags = json['ops'].map do |item|
        item_to_tag(item)
      end
      tags.join
    end

    def item_to_tag(item)
      text = item['insert'].gsub("\n", '<br />')
      attrs = []
      if item['attributes']
        item['attributes'].each_pair do |key, value|
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
      if attrs.empty?
        text
      else
        attrs.inject(text) do |memo, tag_pair|
          "#{tag_pair.first}#{memo}#{tag_pair.last}"
        end
      end
    end
  end
end
