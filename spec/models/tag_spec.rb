require 'rails_helper'

RSpec.describe Tag, :type => :model do
  let(:tag) { Tag.create(name: "snorkel") }

  subject { tag }

  it { should respond_to(:name) }
  it { should respond_to(:passages) }

  it { should be_valid }

  describe "with no name" do
    before { tag.name = "" }
    it { should_not be_valid }
  end

  describe "with name shorter than 2 characters" do
    before { tag.name = "a" }
    it { should_not be_valid }
  end

  describe "with mixed-case name" do
    let(:other) { Tag.create(name: "WhOoAaAoOh") }

    subject { other }

    it { should be_valid }

    it "should force lower-case" do
      expect(other.name).to eq("whooaaaooh")
    end
  end

  describe "with spaces in name" do
    let(:other) { Tag.create(name: "hey you there") }

    subject { other }

    it { should be_valid }

    it "should normalize spaces to dashes" do
      expect(other.name).to eq("hey-you-there")
    end
  end

  describe "with dashes in name" do
    let(:other) { Tag.create(name: "look-ma-there-are-dashes") }

    subject { other }

    it { should be_valid }

    it "should not alter the dashed name" do
      expect(other.name).to eq("look-ma-there-are-dashes")
    end
  end

  describe "with non-dash non-alphanumeric characters in name" do
    let(:other) { Tag.create(name: "hey!!!1!1#%$^&") }

    subject { other }

    it { should_not be_valid }
  end

  describe "with a duplicate name" do
    let(:other) { Tag.create(name: tag.name) }

    subject { other }

    it { should_not be_valid }
  end
end
