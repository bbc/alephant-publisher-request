module Alephant
  module Publisher
    module Request
      class BaseProcessor
        def consume(data)
          raise NotImplementedError.new("You must implement the #consume(data) method")
        end
      end
    end
  end
end
