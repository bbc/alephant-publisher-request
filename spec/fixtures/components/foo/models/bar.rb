module MyApp
  class Bar < Alephant::Publisher::Request::Views::Html
    def content
      @data[:content]
    end
  end
end
