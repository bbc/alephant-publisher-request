require 'alephant/renderer/views/html'

module MyApp
  class Foo < Alephant::Renderer::Views::Html
    def content
      @data[:content]
    end
  end
end
