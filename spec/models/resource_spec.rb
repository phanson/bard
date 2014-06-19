require 'rails_helper'

RSpec.describe Resource, :type => :model do
  let(:book) { ResourceType.create(name: "book") }
  let(:resource) { Resource.create(name: "The Silmarillion",
                                   authors: "J.R.R. Tolkien",
                                   type: book,
                                   date: Date.new(1977, 9, 15)) }

  subject { resource }

  it { should respond_to(:name) }
  it { should respond_to(:authors) }
  it { should respond_to(:type) }
  it { should respond_to(:date) }
  it { should respond_to(:url) }
  it { should respond_to(:passages) }

  it { should be_valid }

  its(:type) { should eq book }

  describe "with no name" do
    before { resource.name = "" }
    it { should_not be_valid }
  end
end
