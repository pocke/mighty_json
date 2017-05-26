# MightyJSON

A faster implementation of [soutaro/strong_json](https://github.com/soutaro/strong_json).

## Benchmarking


![graph](https://cloud.githubusercontent.com/assets/4361134/26479369/9b5848c2-420d-11e7-9ada-83d5f16840df.png)

- In complex case, MightyJSON is faster 2.8x than StrongJSON ([code](https://github.com/pocke/mighty_json/blob/master/benchmarks/large.rb)).
- In simple case, MightyJSON is faster around 2x ~ 10x than StrongJSON ([code](https://github.com/pocke/mighty_json/blob/master/benchmarks/small.rb)).

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
