module MyApp
  class Foo < Alephant::Publisher::Request::Views::Html
    def content
      @data[:content]
    end
  end
end
