require 'spec_helper'
require File.expand_path('../../../lib/memcached/client', __FILE__)

RSpec.describe Memcached::Client do

  before do
    @c = Memcached::Client.new
  end

  context '.initialize' do
    before do
      @servers   = %w{ 192.168.1.1:11211 192.168.1.2:11211 }
      @namespace = 'hoge'
      @test      = Memcached::Client.new({ servers:   @servers,
                                           namespace: @namespace,
                                           compress:  true,
                                           options:   { foo: 'bar' } })
      @options   = Memcached::Client.class_variable_get(:@@_options)
    end

    it '.servers' do
      expect(@test.servers).to eq(@servers)
    end

    it '.namespace' do
      expect(@options[:namespace]).to eq(@namespace)
    end

    it '.compress' do
      expect(@options[:compress]).to eq(true)
    end

    it '.options' do
      expect(@test.options).to eq({namespace: @namespace, compress: true, foo: 'bar' })
    end
  end

  context '.servers' do
    it 'should be raise error with not array' do
      expect{ @c.servers('hoge') }.to raise_error(RuntimeError, 'self.servers must be Array: hoge')
    end

    it 'should be raise error with not valid array' do
      expect{ @c.servers(['hoge:hoge']) }.to raise_error(RuntimeError, 'Invalid format: ["hoge:hoge"]')
    end

    it 'can accept array' do
      array = %w{ 192.168.1.1:11211 192.168.1.2:11211 }
      @c.servers(array)
      expect(@c.servers).to eq(array)
    end
  end

  context '.options' do
    before do
      @c.options({ bar: 'baz' })
      @options = Memcached::Client.class_variable_get(:@@_options)
    end

    it do
      expect(@options[:bar]).to eq('baz')
    end
  end

  context '.namespace' do
    before do
      @c.namespace = 'hoge'
      @options = Memcached::Client.class_variable_get(:@@_options)
    end

    it do
      expect(@options[:namespace]).to eq('hoge')
    end
  end

  context '.compress' do
    before do
      @c.compress = true
      @options = Memcached::Client.class_variable_get(:@@_options)
    end

    it do
      expect(@options[:compress]).to eq(true)
    end
  end

  context '.check_server_format' do

    it 'should be false by "hoge"' do
      expect(@c.send('check_server_format', 'hoge')).to          eq(false)
    end
    it 'should be false by "hoge:111"' do
      expect(@c.send('check_server_format', 'hoge:111')).to      eq(false)
    end
    it 'should be false by "111.111:111"' do
      expect(@c.send('check_server_format', '111.111:111')).to   eq(false)
    end
    it 'should be true by "localhost:111"' do
      expect(@c.send('check_server_format', 'localhost:111')).to eq(true)
    end
    it 'should be true by "127.0.0.1:111"' do
      expect(@c.send('check_server_format', '127.0.0.1:111')).to eq(true)
    end
  end

  it '.connect should be Dalli object' do
    expect(@c.connect).to be_kind_of(Dalli::Client)
  end

end
