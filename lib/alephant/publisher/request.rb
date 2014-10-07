require 'alephant/logger'
require 'alephant/publisher/request/version'
require 'alephant/publisher/request/processor'
require 'rack/request'
require 'rack/response'

module Alephant
  module Publisher
    module Request
      include Logger

      def self.create(opts = {}, processor = nil)
        processor ||= Processor.new(opts)
        Publisher.new(opts, processor)
      end

      class Publisher
        def call(env)
          req      = Rack::Request.new(env)
          response = Rack::Response.new("<h1>Not Found</h1>", 404, { "Content-Type" => "text/html" })

          case req.path_info
          when /status$/
            response = status
          when /component\/(?<id>[^\/]+)$/
            component_id = $~['id']
            response     = Rack::Response.new("<p>#{component_id}</p>", 200, { "Content-Type" => "text/html" })
          end

          response.finish
        rescue Exception => e
          Rack::Response.new("<h1>An exception occured: #{e.message}</h1>", 500, { 'Content-Type' => 'text/html' })
        end

        def initialize(opts, processor = nil)
          @opts = opts
          @processor = processor
        end

        def run!
        end
      end
    end
  end
end
