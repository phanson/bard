require 'rails_helper'

RSpec.describe "Person pages", type: :feature do
  subject { page }

  describe "index page" do
    let(:person1) { Person.create(name: "Marcus Aurelius") }
    let(:person2) { Person.create(name: "Julius Caesar") }

    before do
      person1.save
      person2.save
      visit people_path
    end

    it { should have_link(person1.name, href: person_path(person1)) }
    it { should have_link(person2.name, href: person_path(person2)) }

    it { should have_link('add', href: new_person_path, count: 2) }
  end

  describe "show page" do
    let(:marcus) { Person.create(name: "Marcus Aurelius") }
    let(:passage) { Passage.create(body: "The art of life is more like the wrestler's art than the dancer's, in respect of this, that it should stand ready and firm to meet onsets which are sudden and unexpected.",
                                   author: marcus) }

    before do
      passage.save
      visit person_path(marcus)
    end

    it { should have_selector('h1', text: marcus.name) }
    it { should have_link('edit', href: edit_person_path(marcus)) }
    it { should have_link('delete', href: person_path(marcus)) }
    it { should have_link('back', href: people_path) }

    it { should have_content("1 passage") }
    it { should have_link(passage.body, passage_path(passage)) }

    describe "after clicking 'delete'" do
      before do
        click_on 'delete'
      end

      it "should delete the person" do
        expect(Person.find_by(name: marcus.name)).to eq(nil)
      end
    end
  end

  describe "create page" do
    before do
      visit new_person_path
    end

    it { should have_field("Name") }
    it { should have_button("Create") }
    it { should have_link("Cancel") }

    describe "with invalid name" do
      it "should not create a person" do
        expect { click_button 'Create' }.not_to change(Person, :count)
      end
    end

    describe "with valid name" do
      before do
        fill_in "Name", with: "Aristotle"
      end

      it "should create a person" do
        expect { click_button 'Create' }.to change(Person, :count).by(1)
      end
    end

    describe "when cancel is clicked" do
      describe "should go back to the index" do
        before { click_on 'Cancel' }
        it { should have_selector('h1', text: "People") }
      end

      it "should not create a person" do
        expect { click_on 'Cancel' }.not_to change(Person, :count)
      end
    end
  end

  describe "edit page" do
    let(:person) { Person.create(name: "Weird Al") }
    before do
      visit edit_person_path(person)
    end

    it { should have_selector('h1', text: "Edit Person") }
    it { should have_field("Name", with: person.name) }
    it { should have_button("Save") }
    it { should have_link("Cancel") }

    describe "with invalid name" do
      before do
        fill_in "Name", with: ""
        click_button "Save"
      end

      it { should have_selector('h1', text: "Edit Person") }

      it "should not save changes" do
        person.reload
        expect(person.name).to eq("Weird Al")
      end
    end

    describe "with valid name" do
      before do
        fill_in "Name", with: "Aristotle"
        click_button "Save"
      end

      it { should have_selector('h1', text: "Aristotle") }

      it "should save changes" do
        person.reload
        expect(person.name).to eq("Aristotle")
      end
    end

    describe "when cancel is clicked" do
      before do
        fill_in "Name", with: "Zap Brannigan"
        click_on 'Cancel'
        person.reload
      end

      it { should have_selector('h1', text: person.name) }

      it "should not change the person" do
        expect(person.name).to eq("Weird Al")
      end
    end
  end
end
