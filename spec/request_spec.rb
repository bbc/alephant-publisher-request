require "spec_helper"

describe Alephant::Publisher::Request do
  let (:processor) { instance_double(Alephant::Publisher::Request::Processor, :consume => nil) }
  let (:data_mapper_factory) { instance_double(Alephant::Publisher::Request::DataMapperFactory, :create => nil) }

  describe ".create" do
    context "Using valid params" do
      let (:expected) { Alephant::Publisher::Request::Request }

      specify { expect(subject.create(processor, data_mapper_factory)).to be_a expected }
    end
  end

end
