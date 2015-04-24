require 'alephant/logger'
require 'alephant/publisher/request/version'
require 'alephant/publisher/request/processor'
require 'rack/request'
require 'rack/response'
require 'alephant/publisher/request/error'

module Alephant
  module Publisher
    module Request

      def self.create(processor, data_mapper_factory, opts = {})
        Request.new(processor, data_mapper_factory, opts)
      end

      class Request
        include Logger

        attr_reader :processor, :data_mapper_factory, :opts

        DEFAULT_CONTENT_TYPE = { "Content-Type" => "text/html" }

        def initialize(processor, data_mapper_factory, opts)
          @processor           = processor
          @data_mapper_factory = data_mapper_factory
          @opts                = opts
        end

        def call(env)
          req      = Rack::Request.new(env)
          response = Rack::Response.new("<h1>Not Found</h1>", 404, DEFAULT_CONTENT_TYPE)

          case req.path_info
          when /status$/
            response = Rack::Response.new('ok', 200, DEFAULT_CONTENT_TYPE)
          when /component\/(?<id>[^\/]+)$/
            component_id = $~['id']
            logger.info "Component request for: #{component_id} with options: #{req.params.inspect}"

            response = Rack::Response.new(
              template_data(component_id, req.params),
              200,
              DEFAULT_CONTENT_TYPE
            )
          end

          response.finish
        rescue InvalidApiStatus => e
          error_response(e, e.status)
        rescue ApiError, ConnectionFailed => e
          error_response(e, 502)
        rescue InvalidComponent => e
          error_response(e, 404)
        rescue Exception => e
          error_response e
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

        def error_response(e = "", code = 500)
          logger.error "Publisher::Request#error_response: #{e.message}"
          logger.metric "PublisherRequestErrorResponseStatus#{code}"
          message = opts.fetch(:debug, false) ? e.message : ""
          Rack::Response.new(message, code, DEFAULT_CONTENT_TYPE).finish
        end

      end
    end
  end
end
