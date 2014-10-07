module Alephant
  module Publisher
    module Request
      class DataMapper
        attr_reader :context, :api_host, :connection

        def initialize(api_host, context = {}, connection)
          @context    = context
          @api_host   = api_host
          @connection = connection
        end

        def data
          raise NotImplementedError
        end

        protected

        def get(uri)
          connection.get uri
        end

      end
    end
  end
end
