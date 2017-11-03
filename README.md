# QuillBuilder

QuillBuilder is converter from Quill.js output to HTML and so on.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'quill-builder'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install quill-builder

## Usage

```ruby
# JSON data from quill.getContents()
input = [
  {
    block: :p,
    inlines: [
      { text: 'aaa ', attrs: [] },
      { text: 'bold', attrs: [['<b>', '</b>']] },
      { text: " bbb\n", attrs: [] }
    ]
  }
]
Quill::Builder::HTML.new(input.to_json).convert
# => <p>aaa <b>bold</b> bbb</p>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/space-pirates-llc/quill-builder.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Badges

- [![Build Status](https://travis-ci.org/space-pirates-llc/quill-builder.svg)](https://travis-ci.org/space-pirates-llc/quill-builder)
