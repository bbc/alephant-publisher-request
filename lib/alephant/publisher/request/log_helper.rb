require 'alephant/logger'

module Alephant
  module Publisher
    module Request
      module LogHelper
        include Logger
        def log_error_with_metric(e, method, message, metric = nil, metric_count = 1)
          logger.error "Publisher::Request::#{method}: '#{e.class}(#{e.message})' exception raised for: #{message}"
          logger.metric(:name => metric, :unit => "Count", :value => metric_count) unless metric.nil?
        end
      end
    end
  end
end
