module Alephant
  module Publisher
    module Request
      class DataMapperFactory
        attr_reader :api_host, :connection, :base_path

        def initialize(api_host, connection, base_path)
          @api_host   = api_host
          @connection = connection
          @base_path  = base_path
          raise "Invalid base path: #{base_path}" unless File.directory? base_path
        end

        def create(component_id, context = {})
          require "#{base_path}/components/#{component_id}/mapper"

          klass = Object.const_get(
            "#{component_id.split('_').collect(&:capitalize).join}Mapper"
          )

          klass.new(api_host, context, connection)
        end

      end
    end
  end
end
