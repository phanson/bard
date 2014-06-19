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
end
