module Alephant
  module Publisher
    module Request
      class Error < StandardError; end
      class InvalidApiResponse < Error; end
      class ConnectionFailed < Error; end
      class InvalidComponent < Error; end
      class InvalidComponentBasePath < InvalidComponent; end
      class InvalidComponentName < InvalidComponent; end
      class InvalidComponentClassName < InvalidComponent; end
    end
  end
end

