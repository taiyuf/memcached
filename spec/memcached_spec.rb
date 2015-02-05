require 'spec_helper'

describe Memcached do
  it 'has a version number' do
    expect(Memcached::VERSION).not_to be nil
  end
end
