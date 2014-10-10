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
          response = connection.get(uri)
          raise InvalidApiResponse, "Status: #{response.status}" unless response.status == 200
          JSON::parse(response.body, :symbolize_names => true)
        rescue Faraday::ConnectionFailed
          raise ConnectionFailed
        rescue Error, JSON::ParserError
          raise InvalidApiResponse
        end

      end
    end
  end
end
