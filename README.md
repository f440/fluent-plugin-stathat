# Fluent::Plugin::Stathat, a plugin for [Fluentd](http://fluentd.org)

StatHat output plugin for Fluentd.

## Installation

    $ fluent-gem install fluent-plugin-stathat

## Configuration

    <match stathat.**>
      type  stathat
      ezkey your_email@example.com # The ezkey for your StatHat account

      stat my_graph # stat name (default: tag name)
      count key_name
      # or `value key_name`.
      # this plugin requires either `count` or `value` is required, but not both.
    </match>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
