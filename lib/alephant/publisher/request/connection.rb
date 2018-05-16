require "alephant/logger"
require "alephant/publisher/request/log_helper"

module Alephant
  module Publisher
    module Request
      class Connection
        include Logger
        include Alephant::Publisher::Request::LogHelper
        attr_reader :driver

        def initialize(driver)
          @driver = driver
        end

        def get(uri)
          ::JSON::parse(request(uri).body, :symbolize_names => true)
        rescue Faraday::ConnectionFailed => e
          log_error_with_metric(e, 'Connection#request', uri, "PublisherRequestConnectionConnectionFailed")
          raise ConnectionFailed
        rescue InvalidApiStatus => e
          log_error_with_metric(e, 'Connection#request', uri, "PublisherRequestConnectionInvalidStatus#{e.status}")
          raise e
        rescue ::JSON::ParserError => e
          log_error_with_metric(e, 'Connection#get', uri, "PublisherRequestConnectionInvalidApiResponse")
          raise InvalidApiResponse, "JSON parsing error: #{response.body}"
        rescue StandardError => e
          log_error_with_metric(e, 'Connection#get', uri, "PublisherRequestConnectionApiError")
          raise ApiError, e.message
        end

        private

        def request(uri)
          before = Time.new
          logger.info "Publisher::Request::Connection#request: uri: #{uri}"

          driver.get(uri).tap do |response|
            response_time = Time.new - before
            logger.metric("PublisherRequestConnectionRequestHTTPTime", :unit => "Seconds", :value => response_time)
            logger.info "Publisher::Request::Connection#request: API response time: #{response_time}"
            logger.info "Publisher::Request::Connection#request: status returned: #{response.status} for #{uri}"
            raise InvalidApiStatus, response.status unless response.status == 200
          end
        end
      end
    end
  end
end
