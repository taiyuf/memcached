# coding: utf-8
require 'dalli'

#=lib/memcached/client.rb
#
#== Usage
#
# require 'memcached/client'
# 
# cache = Memcached::Client.new(servers: ... , options: ... ).connect
#
module Memcached

  class Client

    def initialize(hash=nil)

      @@_servers    = []
      @@_options    = {}
      @@_connection = nil

      if hash
        if hash.has_key?(:servers)
          self.servers = hash[:servers]
        else
          self.servers = ['127.0.0.1:11211']
        end

        %i{ namespace compress options }.each do |s|
          self.send(s, hash[s]) if hash.has_key?(s)
        end
      end
    end

    #===
    #
    # @params Array or nil
    # @return Array
    #
    # set array to class variable @@_servers and get class variable @@_servers.
    #
    # @example
    #
    # self.servers = ['localhost:11211']
    # self.servers #=> ['localhost:11211']
    #
    def servers(array=nil)
      unless array.nil?
        raise "self.servers must be Array: #{array}" unless array.class.to_s == 'Array'
        raise "Invalid format: #{array}" unless check_server_format(array)
        @@_servers = array
      end

      @@_servers
    end

    #===
    #
    # @params Hash or nil
    # @return Hash
    #
    # set array to class variable @@_options and get class variable @@_options.
    #
    # @example
    #
    # self.options = { foo: 'bar' }
    # self.options #=> { foo: 'bar' }
    #
    def options(hash=nil)
      unless hash.nil?
        hash.each do |k, v|
          @@_options[k] = v
        end
      end

      @@_options
    end

    #===
    #
    # @params String or nil
    # @return String
    #
    # set array to class variable @@_options[:namespace] and get class variable @@_options[:namespace].
    #
    # @example
    #
    # self.namespace = 'hoge'
    # self.namespace #=> 'hoge' and @@_options[:namespace] = 'hoge'
    #
    def namespace(str=nil)
      unless str.nil?
        @@_options[:namespace] = str
      end

      @@_options[:namespace]
    end

    #===
    #
    # @params True or False or nil
    # @return True or False
    #
    # set array to class variable @@_options[:compress] and get class variable @@_options[:compress].
    #
    # @example
    #
    # self.compress = true
    # self.compress #=> true and @@_options[:compress] = true
    #
    def compress(flag=nil)
      unless flag.nil?
        @@_options[:compress] = flag
      end

      @@_options[:compress]
    end

    alias_method :servers=,   :servers
    alias_method :namespace=, :namespace
    alias_method :compress=,  :compress
    alias_method :options=,   :options

    #===
    # @param  nil
    # @return Dalli::Client [Object]
    #
    # memcachedの操作は、下記のDalliのクライアントに準拠します。
    # https://github.com/mperham/dalli/blob/master/lib/dalli/client.rb
    #
    # @example
    #
    # cache = Memcached::Client.new( ... ).connect
    # cache.set('foo', 'bar') # => {foo => bar}
    # return cache.get('foo') # => 'bar'
    #
    def connect

      @@_connection = Dalli::Client.new(@@_servers , @@_options) unless @@_connection
      @@_connection

    end

    #===
    # @param  nil
    # @return nil
    #
    # Reconnect to Memcached servers.
    #
    # @example
    #
    # cache.reconnect
    #
    def reconnect

      @@_connection = nil
      connect

    end

    private

    def check_server_format(s)
      return false unless /[^:]+:[^:]+/ =~ s.to_s
      if /\d+\.\d+.\d+.\d+:\d+/ =~ s.to_s
        return true
      else
        return /localhost:\d+/ =~ s.to_s ? true : false
      end
      false
    end
  end

end
