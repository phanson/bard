require 'rails_helper'

RSpec.describe ResourceType, :type => :model do
  let(:book) { ResourceType.create(name: "book") }
  subject { book }

  it { should be_valid }

  describe "with empty name" do
    before { book.name = "" }
    it { should_not be_valid }
  end

  describe "with name shorter than 3 characters" do
    before { book.name = "bo" }
    it { should_not be_valid }
  end
end
