require_relative "./spec_helper"

describe Alephant::Publisher::Request do
  include Rack::Test::Methods
  let (:processor) { instance_double(Alephant::Publisher::Request::Processor) }
  let (:data_mapper_factory) { instance_double(Alephant::Publisher::Request::DataMapperFactory) }
  let (:app) { subject.create(processor, data_mapper_factory) }

  describe "GET /component/{param}" do

    context "with a valid parameter" do

      it "returns HTML" do
        get "/component/foo"
        expect(last_response).to be_ok
        expect(last_response.body).to eq "<p>foo</p>"
      end
    end

  end
end
