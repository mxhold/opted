# Opted

Inspired by [Rust](https://www.rust-lang.org/en-US/)'s [Result](https://doc.rust-lang.org/std/result/index.html) type, this gem provides basic value types to represent success (`Ok`) and failure (`Err`) results.

- [API Documentation](http://www.rubydoc.info/gems/opted/1.0.0/Opted/Result/AbstractResult)

**Note**: this is mostly experimental. Since I've only used this for trivial things so far, I suggest using caution before using this anywhere important.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'opted'
```

And then execute:

    $ bundle

## Usage

<!-- BEGIN CODE SAMPLE -->
```ruby
# This gem doesn't polute the top-level namespace
# so it can be handy to alias the classes
Ok = Opted::Result::Ok
Err = Opted::Result::Err

# This code sample is run as a part of this gem's test suite
def assert(value)
  fail "Invalid assertion in README code sample" unless value
end

assert Ok.new(1).unwrap! == 1

begin
  Err.new(:whoops).unwrap!
rescue Opted::Result::UnwrapError => e
  assert e.message =~ /Called #unwrap! on #<Opted::Result::Err:.* @error=:whoops>/
else
  fail
end

result = Ok.new(1)

unwrapped_result = result.match do
  ok { |value| value + 1 }
  err { |error| fail "unreachable" }
end

assert unwrapped_result == 2

# disallows wrapping nil
begin
  Ok.new(nil)
rescue ArgumentError => e
  assert e.message =~ /can't wrap nil/
else
  fail
end

begin
  Err.new(nil)
rescue ArgumentError => e
  assert e.message =~ /can't wrap nil/
else
  fail
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/opted. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Opted project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/opted/blob/master/CODE_OF_CONDUCT.md).
