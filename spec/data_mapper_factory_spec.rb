require 'spec_helper'

describe Alephant::Publisher::Request::DataMapperFactory do
  let (:api_host) { 'https://www.test-api.com' }
  let (:connection) { instance_double(Faraday::Connection, :get => nil) }
  let (:base_path) { File.join(File.dirname(__FILE__), 'fixtures') }

  let (:subject) { Alephant::Publisher::Request::DataMapperFactory.new(api_host, connection, base_path) }

  describe ".create" do
    let (:context) {
      {
        :foo => :bar
      }
    }

    context "using valid parameters" do
      let (:component_id) { 'foo' }
      let (:expected) { FooMapper }

      specify {
        expect(subject.create(component_id, context)).to be_instance_of expected
      }

    end

    context "using invalid path" do
      let (:base_path) { File.join(File.dirname(__FILE__), 'non_existent_path') }

      specify {
        expect{ subject.create(component_id, context) }.to raise_exception RuntimeError
      }

    end

    context "using invalid component name" do
      let (:component_id) { 'bar' }

      specify {
        expect{ subject.create(component_id, context) }.to raise_exception LoadError
      }

    end

  end

end
