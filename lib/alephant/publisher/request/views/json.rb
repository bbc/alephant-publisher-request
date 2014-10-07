require "alephant/publisher/request/views/base"
require "json"

module Alephant
  module Publisher
    module Request
      module Views
        class Json
          include ::Alephant::Publisher::Request::Views::Base

          def setup
            @content_type = "application/json"
          end

          def render
            JSON.generate(to_h)
          end
        end
      end
    end
  end
end
