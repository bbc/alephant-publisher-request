require_relative "./spec_helper"

describe Alephant::Publisher::Request do
  include Rack::Test::Methods

  def app
    subject.create
  end

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
