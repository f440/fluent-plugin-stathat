module Fluent
  class StathatOutput < Fluent::BufferedOutput
    Fluent::Plugin.register_output('stathat', self)

    config_param :ezkey
    config_param :count, :default => nil
    config_param :value, :default => nil
    config_param :stat, :default => nil

    def initialize
      require 'net/https'
      require 'uri'
      require 'json'

      super
    end

    def configure(conf)
      super

      if (@count.nil? && @value.nil?) || (@count && @value)
        raise ConfigError, "stathat_out requires either 'count' or 'value', but not both"
      end

      @uri = URI.parse("https://api.stathat.com/ez")

      @https = Net::HTTP.new(@uri.host, @uri.port)
      @https.use_ssl = true
    end

    def start
      super
    end

    def shutdown
      super
    end

    def format(tag, time, record)
      [tag, time, record].to_msgpack
    end

    def write(chunk)
      data = []
      chunk.msgpack_each do |tag, time, record|
        stat = (@stat || tag)

        if record.has_key? @count
          data << {stat: stat, t: time, count: record[@count]}
        elsif record.has_key? @value
          data << {stat: stat, t: time, value: record[@value]}
        end
      end
      post(ezkey: @ezkey, data: data) if data.length > 0
    end

    def post(data)
      req = Net::HTTP::Post.new(@uri.request_uri)
      req.content_type = 'application/json'
      req.body = data.to_json

      @https.request(req)
    end
  end
end
