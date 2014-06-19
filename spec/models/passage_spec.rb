require 'rails_helper'

RSpec.describe Passage, :type => :model do
  let(:passage) { Passage.create(title: "A Short Diversion",
                                 body: "There once was a man from Nantucket, but this story isn't about him. It isn't about Nantucket, either.") }

  subject { passage }

  it { should respond_to(:title) }
  it { should respond_to(:body) }
  it { should respond_to(:resource) }
  it { should respond_to(:author) }
  it { should respond_to(:tags) }

  it { should be_valid }

  describe "with no title" do
    before { passage.title = "" }
    it { should be_valid }
  end

  describe "with no body" do
    before { passage.body = "" }
    it { should_not be_valid }
  end

  describe "with a body less than 20 characters" do
    before { passage.body = "short body" }
    it { should_not be_valid }
  end

  describe "with a resource" do
    let(:book) { ResourceType.create(name: "book") }
    let(:resource) { Resource.create(name: "The Cryptonomicon",
                                     authors: "Alan Turing and Lawrence Ritchard Waterhouse",
                                     type: book,
                                     date: Date.new(1939, 1, 1)) }
    before do
      passage.resource = resource
      passage.save!
    end

    its(:resource) { should eq resource }

    it "should appear in the resource's list of passages" do
      expect(resource.passages).to include(passage)
    end
  end

  describe "with an author" do
    let(:author) { Person.create(name: "e e cummings") }
    before do
      passage.author = author
      passage.save!
    end

    its(:author) { should eq author }

    it "should appear in the author's list of passages" do
      expect(author.passages).to include(passage)
    end
  end

  describe "with tags" do
    let(:jacobite) { Tag.create(name: "jacobite") }
    let(:loyalist) { Tag.create(name: "loyalist") }
    before do
      passage.tags = [jacobite, loyalist]
      passage.save!
    end

    its(:tags) { should include jacobite }
    its(:tags) { should include loyalist }

    it "should appear in the tags' lists of passages" do
      expect(jacobite.passages).to include(passage)
    end
  end
end
