# schai

[![Build Status](https://travis-ci.org/gin0606/schai.svg?branch=master)](https://travis-ci.org/gin0606/schai)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'schai'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install schai

## Usage

```yaml
# foo.yaml
type: object
properties:
  foo:
    type: string
  bar:
    type: string
    optional: true # default value is `false`
  baz_list:
    type: array
    items:
      include: baz.yaml

# baz.yaml
type: object
properties:
  baz:
    type: string
```

```sh
$ bundle exec schai --yaml foo.yaml --to foo.json
```

```json
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "type": "object",
  "properties": {
    "foo": {
      "type": "string"
    },
    "bar": {
      "type": "string"
    },
    "baz_list": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "baz": {
            "type": "string"
          }
        },
        "required": [
          "baz"
        ]
      }
    }
  },
  "required": [
    "foo",
    "baz_list"
  ]
}
```

## Contributing
1. Fork it ( https://github.com/[my-github-username]/schai/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
