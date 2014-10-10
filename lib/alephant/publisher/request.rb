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

        DEFAULT_CONTENT_TYPE = { "Content-Type" => "text/html" }

        def initialize(processor, data_mapper_factory)
          @processor           = processor
          @data_mapper_factory = data_mapper_factory
        end

        def call(env)
          req      = Rack::Request.new(env)
          response = Rack::Response.new("<h1>Not Found</h1>", 404, DEFAULT_CONTENT_TYPE)

          case req.path_info
          when /status$/
            response = status
          when /component\/(?<id>[^\/]+)$/
            response = Rack::Response.new(
              template_data($~['id'], req.params),
              200,
              DEFAULT_CONTENT_TYPE
            )
          end

          response.finish
        rescue Exception => e
          Rack::Response.new("<h1>An exception occured: #{e.message}</h1>", 500, DEFAULT_CONTENT_TYPE)
        end

        protected

        def render_component(component_id, params)
          Rack::Response.new(
            template_data(component_id, params),
            200,
            { "Content-Type" => "text/html" }
          )
        end

        def template_data(component_id, params)
          mapper = data_mapper_factory.create(component_id, params)
          processor.consume(mapper.data, component_id)
        end

      end
    end
  end
end
