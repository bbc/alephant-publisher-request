require "spec_helper"

describe Fixtures::Components::Foo::FooMapper do
  let (:api_host) { 'http://www.test-api.com' }
  let (:context) { { :foo => :bar } }
  let (:connection) { double('Faraday') }

  subject { Fixtures::Components::Foo::FooMapper.new(api_host, context, connection) }

  describe "#data" do
    let (:expected_data) { { :some => :data } }

    context "with a valid endpoint" do
      before(:each) do
        allow(connection).to receive(:get).with("/some/test/endpoint/#{context.values[0]}").and_return(expected_data)
      end

      specify { expect(subject.data).to eq expected_data }
    end
  end
end
