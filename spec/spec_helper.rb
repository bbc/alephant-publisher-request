require "pry"

require "json"
require "faraday"
require "alephant/renderer"
require "alephant/publisher/request"
require "alephant/publisher/request/error"
require "alephant/publisher/request/data_mapper"
require "alephant/publisher/request/connection"
require "alephant/publisher/request/data_mapper_factory"

require_relative "./fixtures/components/foo/mapper"
