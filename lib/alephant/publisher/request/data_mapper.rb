require 'json'

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
          response = connection.get(uri)
          raise InvalidApiResponse unless response.status == 200
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
