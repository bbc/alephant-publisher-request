module Alephant
  module Publisher
    module Request
      class DataMapperFactory
        attr_reader :api_host, :connection, :base_path

        def initialize(api_host, connection, base_path)
          @api_host   = api_host
          @connection = connection
          @base_path  = base_path
          raise InvalidComponentBasePath, base_path unless File.directory? base_path
        end

        def create(component_id, context = {})
          require base_path_for component_id

          klass = mapper_class_for(component_id)
          klass.new(api_host, context, connection)
        rescue LoadError
          raise InvalidComponentName, component_id
        rescue NameError
          raise InvalidComponentClassName, klass
        rescue
          raise InvalidComponent, "Name: #{component_id}, Class: #{klass}"
        end

        protected

        def base_path_for(component_id)
          "#{base_path}/components/#{component_id}/mapper"
        end

        def camalize(snake_case)
          "#{snake_case.split('_').collect(&:capitalize).join}"
        end

        def mapper_class_for(component_id)
          Object.const_get("#{camalize component_id}Mapper")
        end

      end
    end
  end
end
