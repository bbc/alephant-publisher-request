require 'alephant/logger'

module Alephant
  module Publisher
    module Request
      class Connection
        include Logger
        attr_reader :driver

        def initialize(driver)
          @driver = driver
        end

        def get(uri)
          before   = Time.new
          response = driver.get(uri)
          logger.metric(:name => "PublisherRequestDataMapperRequestHTTPTime", :unit => 'Seconds', :value => Time.new - before)
          raise InvalidApiStatus, response.status unless response.status == 200
          JSON::parse(response.body, :symbolize_names => true)
        rescue Faraday::ConnectionFailed
          logger.metric(:name => "PublisherRequestDataMapperConnectionFailed", :unit => "Count", :value => 1)
          raise ConnectionFailed
        rescue JSON::ParserError
          logger.metric(:name => "PublisherRequestDataMapperInvalidApiResponse", :unit => "Count", :value => 1)
          raise InvalidApiResponse, "JSON parsing error: #{response.body}"
        rescue InvalidApiStatus => e
          logger.metric(:name => "PublisherRequestDataMapperInvalidStatus#{e.status}", :unit => "Count", :value => 1)
          raise e
        rescue StandardError => e
          logger.metric(:name => "PublisherRequestDataMapperApiError", :unit => "Count", :value => 1)
          raise ApiError, e.message
        end
      end
    end
  end
end
