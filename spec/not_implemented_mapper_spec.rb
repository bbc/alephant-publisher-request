require "spec_helper"

describe Alephant::Publisher::Request::DataMapper do
  let (:context) { { :key => :value } }
  let (:connection) { instance_double(Faraday) }

  subject { Alephant::Publisher::Request::DataMapper.new(connection, context) }

  describe ".new" do
    specify { expect(subject).to be_a Alephant::Publisher::Request::DataMapper }
  end

  describe "#data" do
    context "not overridden" do
      specify { expect { subject.data } .to raise_error NotImplementedError }
    end
  end

end
