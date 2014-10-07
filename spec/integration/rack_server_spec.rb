require_relative "./spec_helper"

describe "foo" do
  include Rack::Test::Methods

  def app
    Alephant::Publisher::Request.create
  end

  it "should server HTML content from correct endpoint" do
    get "/component/foo"
    expect(last_response).to be_ok
    expect(last_response.body).to eq "<p>foo</p>"
  end
end
