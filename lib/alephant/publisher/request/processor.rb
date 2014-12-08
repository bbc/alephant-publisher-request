require 'alephant/publisher/request/processor/base'
require 'alephant/renderer'

module Alephant
  module Publisher
    module Request
      class Processor < BaseProcessor
        attr_reader :base_path

        def initialize(base_path)
          @base_path = base_path
        end

        def consume(data, component)
          config = config_for component
          renderer_for(config, data).views[component].render
        end

        def renderer_for(config, data)
          Alephant::Renderer.create(config, data)
        end

        protected

        def config_for(component)
          {
            :renderer_id => component,
            :view_path   => base_path
          }
        end

      end
    end
  end
end
