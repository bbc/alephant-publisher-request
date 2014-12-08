require 'alephant/logger'
require 'json'

module Alephant
  module Publisher
    module Request
      class DataMapper
        include Logger

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
          before = Time.new
          response = connection.get(uri)
          raise InvalidApiResponse, "Status: #{response.status}" unless response.status == 200
          logger.metric(:name => "PublisherRequestDataMapperRequestHTTPTime", :unit => 'Seconds', :value => Time.new - before)
          JSON::parse(response.body, :symbolize_names => true)
        rescue Faraday::ConnectionFailed
          logger.metric(:name => "PublisherRequestDataMapperConnectionFailed", :unit => "Count", :value => 1)
          raise ConnectionFailed
        rescue JSON::ParserError
          logger.metric(:name => "PublisherRequestDataMapperInvalidApiResponse", :unit => "Count", :value => 1)
          raise InvalidApiResponse, "JSON parsing error: #{response.body}"
        rescue StandardError => e
          logger.metric(:name => "PublisherRequestDataMapperApiError", :unit => "Count", :value => 1)
          raise ApiError, e.message
        end

      end
    end
  end
end
