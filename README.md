# Assistor

Simple background processing framework for Ruby

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'assistor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install assistor

## Usage

### 1. Signals
Assistor daemon respond to signals

* `QUIT` - Graceful shutdown, waits for assistants to finish their current request before finishing
* `TERM` / `INT` - Quick shutdown, kills all assistants immediately
* `USR1` - Increment the number of assistant processes by one
* `USR2` - Decrement the number of assistant processes by one

and assistants

* `QUIT` - Graceful shutdown, waits for assistant to finish their current request before finishing
* `TERM` / `INT` - Quick shutdown


## Example
```ruby
#!/usr/bin/env ruby

require 'assistor'

class ExampleJob < Assistor::AbstractJob
  def initialize(i)
    @i = i
  end

  def run
    sleep @i
  end
end

class ExampleQueue < Assistor::AbstractQueue
  def initialize
    @queue = []
  end

  def push(job)
    @queue.push job
  end

  def pop
    @queue.pop
  end
end

queue = ExampleQueue.new
(1..100).each do |i|
  queue.push ExampleJob.new i
end

configuration = Assistor::Configuration.new
configuration.id = 'example'
configuration.size = 3
configuration.delay = 0.2
configuration.exception_handler = Proc.new { |exception| ExceptionHandler.handle(exception) }_
configuration.log_file = File.join(File.expand_path('..',  __FILE__), 'example.log')
configuration.pid_file = File.join(File.expand_path('..',  __FILE__), 'example.pid')

Assistor::Daemon.new(configuration).run(queue)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tkowalewski/assistor. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

