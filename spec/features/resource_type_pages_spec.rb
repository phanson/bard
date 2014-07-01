require 'rails_helper'

RSpec.describe "Resource Type pages", type: :feature do
  subject { page }

  describe "index page" do
    let(:resource_type1) { ResourceType.create(name: "bartholomew") }
    let(:resource_type2) { ResourceType.create(name: "nicodemus") }

    before do
      resource_type1.save
      resource_type2.save
      visit resource_types_path
    end

    it { should have_link(resource_type1.name, href: resource_type_path(resource_type1)) }
    it { should have_link(resource_type2.name, href: resource_type_path(resource_type2)) }

    it { should have_link('add', href: new_resource_type_path, count: 2) }
  end

  describe "show page" do
    let(:resource_type) { ResourceType.create(name: "magazine") }

    describe "without resources" do
      before { visit resource_type_path(resource_type) }
      it { should have_content(resource_type.name) }
      it { should have_link('edit', href: edit_resource_type_path(resource_type)) }
      it { should have_link('delete', href: resource_type_path(resource_type)) }
    end

    describe "with resources" do
      let(:resource) { Resource.create(name: "Wired", type: resource_type) }

      before do
        resource.save!
        visit resource_type_path(resource_type)
      end

      it { should have_content(resource_type.name) }
      it { should have_link('edit', href: edit_resource_type_path(resource_type)) }
      it { should_not have_link('delete', href: resource_type_path(resource_type)) }
      it { should have_content(resource.name) }
      #it { should have_link('view', href: resource_path(resource)) }
    end

    describe "delete link" do
      before { visit resource_type_path(resource_type) }
      it "should remove the resource type" do
        expect { click_on 'delete' }.to change(ResourceType, :count).by(-1)
      end
    end
  end

  describe "create page" do
    before { visit new_resource_type_path }

    it { should have_selector('h1', text: "New Resource Type") }
    it { should have_field("Name") }
    it { should have_button("Create") }
    it { should have_link("Cancel") }

    describe "with invalid name" do
      it "should not create a resource type" do
        expect { click_button "Create" }.not_to change(ResourceType, :count)
      end
    end

    describe "with valid name" do
      before do
        fill_in "Name", with: "comp-sci"
      end

      it "should create a resource type" do
        expect { click_button "Create" }.to change(ResourceType, :count).by(1)
      end
    end

    describe "when cancel is clicked" do
      describe "should go back to the index" do
        before { click_on 'Cancel' }
        it { should have_selector('h1', text: "Resource Types") }
      end

      it "should not create a resource_type" do
        expect { click_on 'Cancel' }.not_to change(ResourceType, :count)
      end
    end
  end

  describe "edit page" do
    let(:resource_type) { ResourceType.create(name: "moon") }
    before do
      resource_type.save
      visit edit_resource_type_path(resource_type)
    end

    it { should have_selector('h1', text: "Edit Resource Type") }
    it { should have_field("Name", with: resource_type.name) }
    it { should have_button("Save") }
    it { should have_link("Cancel") }

    describe "with invalid name" do
      before do
        fill_in "Name", with: ""
        click_button "Save"
      end

      it { should have_selector('h1', text: "Edit Resource Type") }

      it "should not save changes" do
        resource_type.reload
        expect(resource_type.name).to eq("moon")
      end
    end

    describe "with valid name" do
      before do
        fill_in "Name", with: "sun"
        click_button "Save"
      end

      it { should have_selector('h1', text: "sun") }

      it "should save changes" do
        resource_type.reload
        expect(resource_type.name).to eq("sun")
      end
    end

    describe "when cancel is clicked" do
      before do
        fill_in "Name", with: "mars"
        click_on 'Cancel'
        resource_type.reload
      end

      it { should have_selector('h1', text: resource_type.name) }

      it "should not change the resource_type" do
        expect(resource_type.name).to eq("moon")
      end
    end
  end
end
