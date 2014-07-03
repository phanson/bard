require 'rails_helper'

RSpec.describe "Passage pages", type: :feature do
  subject { page }

  describe "index page" do
    let(:author) { Person.create(name: "Thomas Jefferson") }
    let(:bare_passage) { Passage.create(body: "This is a passage with no title.",
                                        author: author) }

    let(:type) { ResourceType.create(name: "Book") }
    let(:resource) { Resource.create(name: "Some Book",
                                     authors: "Some Guy and Some Other Guy",
                                     type: type) }
    let(:titled_passage) { Passage.create(title: "Excerpt From a Book",
                                          body: "This is a passage with a title.",
                                          resource: resource) }
    before do
      bare_passage.save
      titled_passage.save
      visit passages_path
    end

    it { should have_selector('h1', text: "Passages") }

    it { should have_link(bare_passage.body, passage_path(bare_passage)) }
    it { should have_link(author.name, person_path(author)) }

    it { should have_link(titled_passage.title, passage_path(titled_passage)) }
    it { should have_link(resource.name, resource_path(resource)) }
  end

  describe "show page" do
    let(:type) { ResourceType.create(name: "Book") }
    let(:resource) { Resource.create(name: "Some Book",
                                     authors: "Some Guy and Some Other Guy",
                                     type: type) }
    let(:passage) { Passage.create(body: "This is a passage without a title.",
                                   resource: resource) }
    before do
      passage.save
      visit passage_path(passage)
    end

    it { should have_selector('h1', text: "Passage") }
    it { should have_content(passage.body) }
    it { should have_link(resource.name, resource_path(resource)) }
    it { should have_content(resource.authors) }
    it { should have_content(type.name) }

    it { should have_link('edit', href: edit_passage_path(passage)) }
    it { should have_link('delete', href: passage_path(passage)) }

    it "should remove passage when delete is clicked" do
      expect { click_on "delete" }.to change(Passage, :count).by(-1)
    end

    describe "when delete is clicked" do
      before { click_on "delete" }
      it { should have_selector('h1', "Passages") }
    end
  end

  describe "show page" do
    let(:author) { Person.create(name: "Thomas Jefferson") }
    let(:passage) { Passage.create(title: "The Meaning of Butterflies",
                                   body: "This is a passage with a title.",
                                   author: author) }
    before do
      passage.save
      visit passage_path(passage)
    end

    it { should have_selector('h1', text: "Passage") }
    it { should have_content(passage.title) }
    it { should have_content(passage.body) }
    it { should have_link(author.name, href: person_path(author)) }

    it { should have_link('edit', href: edit_passage_path(passage)) }
    it { should have_link('delete', href: passage_path(passage)) }
  end

  describe "create page" do
    let(:type) { ResourceType.create(name: "Thesis") }
    let(:resource) { Resource.create(name: "On The Proliferation of Monofilament Violins",
                                     authors: "Matthew Broderick",
                                     type: type) }
    let(:author) { Person.create(name: "Sun Zhou") }
    before do
      author.save
      resource.save
      visit new_passage_path
    end

    it { should have_selector('h1', "New Passage") }
    it { should have_field("Title") }
    it { should have_field("Body") }
    it { should have_select("Resource") }
    it { should have_select("Author") }
    it { should have_link("Cancel", href: passages_path) }
    it { should have_button("Create") }

    describe "after clicking cancel" do
      it "should not create a passage" do
        expect { click_on "Cancel" }.not_to change(Passage, :count)
      end

      describe "go back to the index page" do
        before { click_on "Cancel" }
        it { should have_selector('h1', "Passages") }
      end
    end

    describe "with valid data" do
      before do
        fill_in "Title", with: "A Marked Departure"
        fill_in "Body", with: "It was not until the late 23rd century that the true power of monofilament violins for torture was discovered..."
        select resource.name, from: "Resource"
      end

      it "should create a new passage" do
        expect { click_on "Create" }.to change(Passage, :count).by(1)
      end

      describe "after clicking create" do
        before { click_on "Create" }
        it { should have_selector('h1', text: "Passage") }
        it { should have_content("A Marked Departure") }
        it { should have_content(resource.name) }
        it { should_not have_content(author.name) }
      end
    end

    describe "with valid data" do
      before do
        fill_in "Body", with: "The natural state of copper is residential plumbing. We are merely restoring it."
        select author.name, from: "Author"
      end

      it "should create a new passage" do
        expect { click_on "Create" }.to change(Passage, :count).by(1)
      end

      describe "after clicking create" do
        before { click_on "Create" }
        it { should have_selector('h1', text: "Passage") }
        it { should have_content("The natural state of copper") }
        it { should have_content(author.name) }
        it { should_not have_content(resource.name) }
      end
    end

    describe "with invalid data" do
      before do
        fill_in "Body", with: "Way too short"
      end

      it "should not create a new passage" do
        expect { click_on "Create" }.not_to change(Passage, :count)
      end

      describe "after clicking create" do
        before { click_on "Create" }
        it { should have_selector('h1', text: "New Passage") }
      end
    end
  end

  describe "edit page" do
    let(:type) { ResourceType.create(name: "Thesis") }
    let(:resource) { Resource.create(name: "On The Proliferation of Monofilament Violins",
                                     authors: "Matthew Broderick",
                                     type: type) }
    let(:author) { Person.create(name: "Sun Zhou") }
    let(:passage) { Passage.create(title: "Made in China",
                                   body: "This quote is a 100% genuine export of Xaioming.",
                                   resource: resource,
                                   author: author) }
    before do
      author.save
      resource.save
      passage.save
      visit edit_passage_path(passage)
    end

    it { should have_selector('h1', "Edit Passage") }
    it { should have_field("Title", with: passage.title) }
    it { should have_field("Body", with: passage.body) }
    it { should have_select("Resource", text: resource.name) }
    it { should have_select("Author", text: author.name) }
    it { should have_link("Cancel", href: passages_path) }
    it { should have_button("Save") }

    describe "after clicking cancel" do
      before { click_on "Cancel" }
      it { should have_selector('h1', "Passage") }
    end

    describe "with valid data" do
      before do
        fill_in "Title", with: "A Marked Departure"
        fill_in "Body", with: "It was not until the late 23rd century that the true power of monofilament violins for torture was discovered..."
        select resource.name, from: "Resource"
        select "", from: "Author"
        click_on "Save"
      end

      it { should have_selector('h1', text: "Passage") }
      it { should have_content("A Marked Departure") }
      it { should have_content(resource.name) }
      it { should_not have_content(author.name) }
    end

    describe "with valid data" do
      before do
        fill_in "Body", with: "The natural state of copper is residential plumbing. We are merely restoring it."
        select author.name, from: "Author"
        select "", from: "Resource"
        click_on "Save"
      end

      it { should have_selector('h1', text: "Passage") }
      it { should have_content("The natural state of copper") }
      it { should have_content(author.name) }
      it { should_not have_content(resource.name) }
    end

    describe "with invalid data" do
      before do
        fill_in "Body", with: "Way too short"
      end

      it "should not create a new passage" do
        expect { click_on "Save" }.not_to change(Passage, :count)
      end

      describe "after clicking create" do
        before { click_on "Save" }
        it { should have_selector('h1', text: "Edit Passage") }
      end
    end
  end
end
