require "spec_helper"

describe Fixtures::Components::Foo::Mappers::FooMapper do
  let (:api_host) { 'http://www.test-api.com' }
  let (:context) { { :foo => :bar } }
  let (:connection) { double('Faraday') }

  describe "#data" do
    let (:expected_data) { { :some => :data } }
    let (:instance) { Fixtures::Components::Foo::Mappers::FooMapper.new(api_host, context, connection) }

    before(:each) do
      allow(connection).to receive(:get).with("/some/test/endpoint/#{context.values[0]}").and_return(expected_data)
    end

    context "Correct endpoint is called" do
      specify { expect(instance.data).to eq expected_data }
    end
  end
end
