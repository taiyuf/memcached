# Memcached

Simple interface for memcached for ruby.
'Dalli' required.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'memcached', '~> 0.0.2', github: 'taiyuf/ruby-memcached'
```

## Usage

```ruby
require 'memcached'

@cache = Memcached::Client.new( ... ).connect

@cache.set('foo', 'bar')
@cache.get('foo')    # => 'bar'
@cache.delete('foo') # => nil
```

So, the connect method return the Dalli::Client object, you can
use Dalli::Client method by instance.

See https://github.com/mperham/dalli

## Contributing

1. Fork it ( https://github.com/[my-github-username]/memcached/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
