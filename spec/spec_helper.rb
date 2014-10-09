require 'pry'

require 'aws-sdk'
require 'faraday'
require 'alephant/publisher/request'
require 'alephant/publisher/request/view_mapper'
require 'alephant/publisher/request/views'
require 'alephant/publisher/request/views/json'
require 'alephant/publisher/request/views/html'
require 'alephant/publisher/request/data_mapper'
require 'alephant/publisher/request/data_mapper_factory'

require_relative './fixtures/components/foo/mapper'
