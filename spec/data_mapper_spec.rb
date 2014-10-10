require "spec_helper"

describe FooMapper do
  let (:connection) { instance_double(Faraday::Connection, :get => nil) }
  let (:context) do
    {
      :foo => :bar
    }
  end

  subject { described_class.new(connection, context) }

  describe "#data" do
    let (:expected_raw_data) do
      {
        :some => 'data'
      }
    end
    let (:expected_data) { JSON::generate(expected_raw_data, :symbolize_names => true) }
    let (:expected_response) { instance_double(Faraday::Response, :body => expected_data, :status => 200) }

    context "with a valid endpoint" do
      before(:each) do
        allow(connection).to receive(:get).with("/some/test/endpoint/#{context.values[0]}").and_return(expected_response)
      end

      specify { expect(subject.data).to eq expected_raw_data }
    end

    context "invalid hostname" do
      let (:expected_exception) { Alephant::Publisher::Request::ConnectionFailed }
      let (:faraday_exception) { Faraday::ConnectionFailed.new(StandardError) }

      before(:each) do
        allow(connection).to receive(:get).and_raise(faraday_exception)
      end

      specify { expect{ subject.data }.to raise_error expected_exception }
    end
  end
end
