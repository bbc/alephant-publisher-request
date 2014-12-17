require "alephant/logger"

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
          before = Time.new
          logger.info "Publisher::Request::DataMapper#get: #{uri}"
          response = driver.get(uri)
          logger.metric(:name => "PublisherRequestDataMapperRequestHTTPTime", :unit => 'Seconds', :value => Time.new - before)
          logger.info "Publisher::Request::DataMapper#get: status returned: #{response.status} for #{uri}"
          raise InvalidApiStatus, response.status unless response.status == 200
          JSON::parse(response.body, :symbolize_names => true)
        rescue Faraday::ConnectionFailed => e
          log(e, uri, "PublisherRequestDataMapperConnectionFailed", :unit => "Count", :value => 1)
          raise ConnectionFailed
        rescue JSON::ParserError => e
          log(e, uri, "PublisherRequestDataMapperInvalidApiResponse", 1)
          raise InvalidApiResponse, "JSON parsing log_error: #{response.body}"
        rescue InvalidApiStatus => e
          log(e, uri, "PublisherRequestDataMapperInvalidStatus#{e.status}", 1)
          raise e
        rescue StandardError => e
          log(e, uri, "PublisherRequestDataMapperApiError", 1)
          raise ApiError, e.message
        end

        private

        def log(e, uri, metric = nil, metric_count = 1)
          logger.error "Publisher::Request::DataMapper#get: '#{e.class}(#{e.message})' exception raised for: #{uri}"
          logger.metric(:name => metric, :unit => "Count", :value => metric_count) unless metric.nil?
        end
      end
    end
  end
end
