require 'alephant/logger'

module Alephant
  module Publisher
    module Request
      class DataMapperFactory
        include Logger

        attr_reader :connection, :base_path

        def initialize(connection, base_path)
          @connection = connection
          @base_path  = base_path
          raise InvalidComponentBasePath, base_path unless File.directory? base_path
        end

        def create(component_id, context = {})
          require base_path_for component_id

          klass = mapper_class_for(component_id)
          klass.new(connection, context)
        rescue LoadError => e
          log(e, component_id, "PublisherRequestDataMapperFactoryInvalidComponentName")
          raise InvalidComponentName, "Invalid component name: #{component_id}"
        rescue NameError
          log(e, component_id, "PublisherRequestDataMapperFactoryInvalidComponentClassName")
          raise InvalidComponentClassName, "Invalid class name #{klass}"
        rescue
          log(e, component_id, "PublisherRequestDataMapperFactoryInvalidComponent")
          raise InvalidComponent, "Name: #{component_id}, Class: #{klass}"
        end

        protected

        def base_path_for(component_id)
          "#{base_path}/#{component_id}/mapper"
        end

        def camalize(snake_case)
          "#{snake_case.split('_').collect(&:capitalize).join}"
        end

        def mapper_class_for(component_id)
          Object.const_get("#{camalize component_id}Mapper")
        end

        def log(e, component, metric = nil, metric_count = 1)
          logger.error "Publisher::Request::DataMapperFactory#create#{method}: '#{e.class}(#{e.message})' exception raised for component: #{component}"
          logger.metric(:name => metric, :unit => "Count", :value => metric_count) unless metric.nil?
        end
      end
    end
  end
end
