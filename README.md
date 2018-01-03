# Opted

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/opted`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'opted'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install opted

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
rescue => e
  assert e.message == "Called #unwrap! on Err(:whoops)"
end

result = Ok.new(1)

unwrapped_result = result.match do |m|
  m.ok { |result| result + 1 }
  m.err { |error| fail "unreachable" }
end

assert unwrapped_result == 2
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
