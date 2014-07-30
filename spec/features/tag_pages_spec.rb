require 'rails_helper'

RSpec.describe "Tag pages", type: :feature do
  subject { page }

  describe "index page" do
    let(:tag1) { Tag.create(name: "bartholomew") }
    let(:tag2) { Tag.create(name: "nicodemus") }

    before do
      tag1.save
      tag2.save
      visit tags_path
    end

    it { should have_link(tag1.name, href: tag_path(tag1)) }
    it { should have_link(tag2.name, href: tag_path(tag2)) }

    it { should have_link('add', href: new_tag_path, count: 2) }
  end

  describe "show page" do
    let(:tag) { Tag.create(name: "bartholomew") }

    describe "without passages" do
      before { visit tag_path(tag) }
      it { should have_content(tag.name) }
      it { should have_link('edit', href: edit_tag_path(tag)) }
      it { should have_link('delete', href: tag_path(tag)) }
      it { should have_link('back', href: tags_path) }
    end

    describe "with passages" do
      let(:passage) { Passage.create(body: "This is a passage body yes it is.",
                                     tags: [tag]) }

      before do
        passage.save!
        visit tag_path(tag)
      end

      it { should have_content(tag.name) }
      it { should have_link('edit', href: edit_tag_path(tag)) }
      it { should_not have_link('delete', href: tag_path(tag)) }
      it { should have_link('back', href: tags_path) }
      it { should have_link(passage.body, passage_path(passage)) }
    end

    describe "delete link" do
      before { visit tag_path(tag) }
      it "should remove the tag" do
        expect { click_on 'delete' }.to change(Tag, :count).by(-1)
      end
    end
  end

  describe "create page" do
    before { visit new_tag_path }

    it { should have_selector('h1', text: "New Tag") }
    it { should have_field("Name") }
    it { should have_button("Create") }
    it { should have_link("Cancel") }

    describe "with invalid name" do
      it "should not create a tag" do
        expect { click_button "Create" }.not_to change(Tag, :count)
      end
    end

    describe "with valid name" do
      before do
        fill_in "Name", with: "comp-sci"
      end

      it "should create a tag" do
        expect { click_button "Create" }.to change(Tag, :count).by(1)
      end
    end

    describe "when cancel is clicked" do
      describe "should go back to the index" do
        before { click_on 'Cancel' }
        it { should have_selector('h1', text: "Tags") }
      end

      it "should not create a tag" do
        expect { click_on 'Cancel' }.not_to change(Tag, :count)
      end
    end
  end

  describe "edit page" do
    let(:tag) { Tag.create(name: "moon") }
    before do
      tag.save
      visit edit_tag_path(tag)
    end

    it { should have_selector('h1', text: "Edit Tag") }
    it { should have_field("Name", with: tag.name) }
    it { should have_button("Save") }
    it { should have_link("Cancel") }

    describe "with invalid name" do
      before do
        fill_in "Name", with: ""
        click_button "Save"
      end

      it { should have_selector('h1', text: "Edit Tag") }

      it "should not save changes" do
        tag.reload
        expect(tag.name).to eq("moon")
      end
    end

    describe "with valid name" do
      before do
        fill_in "Name", with: "sun"
        click_button "Save"
      end

      it { should have_selector('h1', text: "sun") }

      it "should save changes" do
        tag.reload
        expect(tag.name).to eq("sun")
      end
    end

    describe "when cancel is clicked" do
      before do
        fill_in "Name", with: "mars"
        click_on 'Cancel'
        tag.reload
      end

      it { should have_selector('h1', text: tag.name) }

      it "should not change the tag" do
        expect(tag.name).to eq("moon")
      end
    end
  end
end
