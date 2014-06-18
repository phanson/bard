require 'rails_helper'

RSpec.describe Person, :type => :model do
  let(:poe) { Person.create(name: "Edgar Allan Poe") }

  subject { poe }

  it { should be_valid }

  describe "when name is empty" do
    before { poe.name = "" }
    it { should_not be_valid }
  end
end
