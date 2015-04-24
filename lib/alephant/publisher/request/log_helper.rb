require 'alephant/logger'

module Alephant
  module Publisher
    module Request
      module LogHelper
        include Logger
        def log_error_with_metric(e, method, message, metric = nil)
          logger.error "Publisher::Request::#{method}: '#{e.class}(#{e.message})' exception raised for: #{message}"
          logger.metric metric unless metric.nil?
        end
      end
    end
  end
end
