require "spec_helper"

describe Alephant::Publisher::Request::Connection do
  let (:driver) { instance_double(Faraday::Connection, :get => nil) }
  let (:uri) { "/foo/bar/baz" }

  subject { described_class.new driver }

  describe "#get" do
    let (:expected_raw_data) do
      {
        :some => 'data'
      }
    end
    let (:expected_data) { JSON.generate(expected_raw_data, :symbolize_names => true) }
    let (:expected_response) { instance_double(Faraday::Response, :body => expected_data, :status => 200) }

    context "with a valid endpoint" do
      before(:each) do
        allow(driver).to receive(:get).and_return(expected_response)
      end

      specify { expect(subject.get(uri)).to eq expected_raw_data }
    end

    context "invalid hostname" do
      let (:expected_exception) { Alephant::Publisher::Request::ConnectionFailed }
      let (:faraday_exception) { Faraday::ConnectionFailed.new(StandardError) }

      before(:each) do
        allow(driver).to receive(:get).and_raise(faraday_exception)
      end

      specify { expect { subject.get(uri)}.to raise_error expected_exception }
    end

    context "invalid status code" do
      let (:status_code) { 503 }
      let (:expected_exception) { Alephant::Publisher::Request::InvalidApiStatus }
      before(:each) do
        allow(driver).to receive(:get).and_return(OpenStruct.new(:status => status_code))
      end

      specify { expect { subject.get(uri)}.to raise_error expected_exception }
    end
  end
end
