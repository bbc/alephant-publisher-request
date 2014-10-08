require "spec_helper"

describe Alephant::Publisher::Request::DataMapper do
  let (:api_host) { 'http://www.test-api.com' }
  let (:context) { { :key => :value } }
  let (:connection) { double('Faraday') }
  let (:instance) { Alephant::Publisher::Request::DataMapper.new(api_host, context, connection) }

  describe ".new" do
    specify { expect(instance).to be_instance_of Alephant::Publisher::Request::DataMapper }

  end

  describe "#data" do
    it "Throws an exception when not overridden" do
      expect { instance.data } .to raise_error NotImplementedError
    end
  end

end
