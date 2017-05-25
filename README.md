# MightyJSON

A faster implementation of [soutaro/strong_json](https://github.com/soutaro/strong_json).

## Benchmarking

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mighty_json'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mighty_json

## Usage

See [soutaro/strong_json](https://github.com/soutaro/strong_json/blob/master/README.md).

## Compatibility

MightyJSON does not have the following methods.

- `Type::Object#merge`
- `Type::Object#except`
- `Type::*#coerce`
- `Type::*#===`
- `Type::*#=~`

MightyJSON does not support literal type that is not serializable by `Object#inspect` method.


## License

See [LICENSE.txt](https://github.com/pocke/mighty_json/blob/master/LICENSE.txt) and [LICENSE.txt.original](https://github.com/pocke/mighty_json/blob/master/LICENSE.txt.original).
This code bases [soutaro/strong_json](https://github.com/soutaro/strong_json).
