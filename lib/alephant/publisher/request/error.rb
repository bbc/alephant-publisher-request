module Alephant
  module Publisher
    module Request
      class Error < StandardError; end
      class ConnectionFailed < Error; end
      class InvalidComponent < Error; end
      class ApiError < Error; end
      class InvalidApiResponse < ApiError; end
      class InvalidComponentBasePath < InvalidComponent; end
      class InvalidComponentName < InvalidComponent; end
      class InvalidComponentClassName < InvalidComponent; end
      class InvalidApiStatus < ApiError
        attr_accessor :status

        def initialize(status)
          @status = status
          super("Status: #{status}")
        end

      end
    end
  end
end

