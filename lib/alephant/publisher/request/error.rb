module Alephant
  module Publisher
    module Request
      class Error < StandardError; end
      class InvalidApiResponse < Error; end
      class ConnectionFailed < Error; end
      class InvalidComponentBasePath < Error; end
      class InvalidComponentName < Error; end
    end
  end
end

