require 'json'

module Alephant
  module Publisher
    module Request
      class DataMapper
        attr_reader :connection, :context

        def initialize(connection, context = {})
          @connection = connection
          @context    = context
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
