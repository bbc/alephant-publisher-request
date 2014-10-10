require 'alephant/logger'
require 'alephant/publisher/request/version'
require 'alephant/publisher/request/processor'
require 'rack/request'
require 'rack/response'
require 'alephant/publisher/request/error'

module Alephant
  module Publisher
    module Request
      include Logger

      def self.create(processor, data_mapper_factory)
        Request.new(processor, data_mapper_factory)
      end

      class Request
        attr_reader :processor, :data_mapper_factory

        def initialize(processor, data_mapper_factory)
          @processor           = processor
          @data_mapper_factory = data_mapper_factory
        end

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

      end
    end
  end
end
