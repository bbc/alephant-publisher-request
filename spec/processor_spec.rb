require "spec_helper"

describe Alephant::Publisher::Request::Processor do
  let (:base_path) { File.join(File.dirname(__FILE__), 'fixtures', 'components') }
  subject { described_class.new(base_path) }

  describe ".new" do
    specify { expect(subject).to be_a described_class }
  end

  describe "#consume" do
    let (:data) do
      {
        :content => "Foo Bar"
      }
    end

    context "using valid data" do
      let (:component) { "foo" }

      specify { expect(subject.consume(data, component)).to eq "#{data.values.first}\n" }
    end

  end
end
