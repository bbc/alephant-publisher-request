require_relative "./spec_helper"

describe Alephant::Publisher::Request do
  include Rack::Test::Methods
  let (:response) { instance_double(Faraday::Response, :status => 200, :body => nil) }
  let (:base_path) { File.join(File.dirname(__FILE__), '..', 'fixtures', 'components') }
  let (:processor) { Alephant::Publisher::Request::Processor.new(base_path) }
  let (:driver) { instance_double(Faraday::Connection, :get => response) }
  let (:connection) { Alephant::Publisher::Request::Connection.new driver }
  let (:data_mapper_factory) { Alephant::Publisher::Request::DataMapperFactory.new(connection, base_path) }
  let (:app) { subject.create(processor, data_mapper_factory, { :debug => true }) }

  describe "status endpoint (/status)" do
    before(:each) do
      get "/status"
    end

    context "status code" do
      specify { expect(last_response.status).to eq 200 }
    end
  end

  describe "component endpoint (/component/{component_id}?foo=bar)" do
    let (:component_id) { "foo" }

    describe "content" do

      context "with a valid component id" do
        let (:api_response) { "{\"content\":\"#{component_id}\"}" }
        before(:each) do
          allow(response).to receive(:body).and_return(api_response)
          get "/component/#{component_id}"
        end

        specify { expect(last_response.body.chomp).to eq component_id }
      end

    end

    describe "status code" do

      context "with an invalid component id" do
        let (:component_id) { "foo_invalid" }
        before(:each) do
          get "/component/#{component_id}"
        end

        specify { expect(last_response.status).to eq 404 }
      end

      context "with an invalid status code" do
        let (:status_code) { 503 }
        let (:expected_exception) { Alephant::Publisher::Request::InvalidApiStatus.new(status_code) }
        before(:each) do
          allow(connection).to receive(:get).and_raise expected_exception
          get "/component/#{component_id}"
        end

        specify { expect(last_response.status).to eq status_code }
      end

      context "with an invalid API endpoint" do
        let (:status_code) { 502 }
        let (:expected_exception) { Alephant::Publisher::Request::InvalidApiResponse }
        before(:each) do
          allow(connection).to receive(:get).and_raise expected_exception
          get "/component/#{component_id}"
        end

        specify { expect(last_response.status).to eq status_code }
      end

    end
  end
end
