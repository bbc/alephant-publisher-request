require "spec_helper"

describe Alephant::Publisher::Request::Processor do
  let (:base_path) { File.join(File.dirname(__FILE__), 'fixtures', 'components') }
  subject { described_class.new(base_path) }

  describe ".new" do
    let (:expected) { described_class }

    specify { expect(subject).to be_a expected }
  end

  describe "#consume" do
    let (:data) do
      {
        :content => "Foo Bar"
      }
    end

    context "using valid data" do
      let (:component_id) { "foo" }

      specify { expect(subject.consume(data, component_id)).to eq "#{data.values.first}\n" }
    end

  end
end
