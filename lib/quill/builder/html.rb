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
            attrs << 'font-weight: bold;'
          when 'italic'
            attrs << 'font-style: italic;'
          when 'color'
            attrs << "color: #{value}"
          end
        end
      end
      if attrs.empty?
        text
      else
        %Q|<span style="#{attrs.join(' ')}">#{text}</span>|
      end
    end
  end
end
