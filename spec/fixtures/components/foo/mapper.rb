class FooMapper < Alephant::Publisher::Request::DataMapper

  def data
    get "/some/test/endpoint/#{context[:foo]}"
  end
end
