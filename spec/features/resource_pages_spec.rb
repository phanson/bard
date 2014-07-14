require 'rails_helper'

RSpec.describe "Resource pages", type: :feature do
  subject { page }

  describe "index page" do
    let(:type) { ResourceType.create(name: "Epic") }
    let(:resource) { Resource.create(name: "The Iliad",
                                     authors: "Homer",
                                     type: type) }
    before do
      resource.save
      visit resources_path
    end

    it { should have_selector('h1', text: "Resources") }
    it { should have_link(resource.name, href: resource_path(resource)) }

    it { should have_link("add", href: new_resource_path, count: 2) }
  end

  describe "show page" do
    let(:type) { ResourceType.create(name: "Epic") }
    let(:resource) { Resource.create(name: "The Iliad",
                                     authors: "Homer",
                                     type: type) }
    before do
      resource.save
      visit resource_path(resource)
    end

    it { should have_selector('h1', text: resource.name) }
    it { should have_content("Authors") }
    it { should have_content(resource.authors) }
    it { should have_content("Type") }
    it { should have_link(type.name, href: resource_type_path(type)) }
    it { should_not have_content("Date") }

    it { should have_link('edit', href: edit_resource_path(resource)) }
    it { should have_link('delete', href: resource_path(resource)) }

    describe "when resource has a date" do
      before do
        resource.date = Date.new(1593, 3, 14)
        resource.save
        visit resource_path(resource)
      end

      it { should have_content("Date") }
      it { should have_content("1593-03-14") }
    end

    describe "when delete is clicked" do
      before { click_on "delete" }

      it { should have_selector('h1', "Resources") }
      it { should_not have_content(resource.name) }
    end
  end

  describe "create page" do
    let(:type) { ResourceType.create(name: "Book") }
    before do
      type.save
      visit new_resource_path
    end

    it { should have_selector('h1', text: "New Resource") }
    it { should have_field('Name') }
    it { should have_field('Authors') }
    it { should have_field('Type') }
    it { should have_field('Date') }
    it { should have_field('URL') }
    it { should have_link('Cancel') }
    it { should have_button('Create') }

    describe "with valid data" do
      before do
        fill_in "Name", with: "The Prince"
        fill_in "Authors", with: "Niccolo Machiavelli"
        select "Book", from: "Type"
      end

      it "should create a resource when create is clicked" do
        expect { click_on "Create" }.to change(Resource, :count).by(1)
      end
    end

    describe "with valid data" do
      before do
        fill_in "Name", with: "The Prince"
        fill_in "Authors", with: "Niccolo Machiavelli"
        select "Book", from: "Type"
        click_on "Create"
      end

      it { should have_selector('h1', text: "The Prince") }
    end

    describe "with invalid data" do
      it "should not create a resource" do
        expect { click_on "Create" }.not_to change(Resource, :count)
      end
    end

    it "should not create a resource when cancel is clicked" do
      expect { click_on "Cancel" }.not_to change(Resource, :count)
    end

    describe "after clicking cancel" do
      before do
        click_on "Cancel"
      end

      it { should have_selector('h1', "Resources") }
    end
  end

  describe "edit page" do
    let(:type) { ResourceType.create(name: "Book") }
    let(:resource) { Resource.create(name: "Life on the Mississippi",
                                     authors: "Mark Twain",
                                     type: type,
                                     date: Date.new(1883)) }
    before do
      resource.save
      visit edit_resource_path(resource)
    end

    it { should have_selector('h1', text: "Edit Resource") }
    it { should have_field('Name', with: resource.name) }
    it { should have_field('Authors', with: resource.authors) }
    it { should have_select('Type', text: resource.type.name) }
    it { should have_field('Date', with: resource.date) }
    it { should have_field('URL') }
    it { should have_link('Cancel') }
    it { should have_button('Save') }

    describe "with valid data" do
      before do
        fill_in "Name", with: "The Prince"
        fill_in "Authors", with: "Niccolo Machiavelli"
        select "Book", from: "Type"
        click_on "Save"
      end

      it { should have_selector('h1', text: "The Prince") }
    end

    describe "with invalid data" do
      before do
        fill_in "Name", with: ""
        click_on "Save"
      end

      it { should have_selector('h1', text: "Edit Resource") }
    end

    describe "after clicking cancel" do
      before do
        click_on "Cancel"
      end

      it { should have_selector('h1', resource.name) }
    end
  end
end
