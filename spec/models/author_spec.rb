require 'rails_helper'

RSpec.describe Author, type: :model do
  let!(:author1) { create(:author, name: "Author A", created_at: 2.days.ago) }
  let!(:author2) { create(:author, name: "Author B", created_at: 1.day.ago) }

  describe "associations" do
    it { should have_many(:book_authors).dependent(:destroy) }
    it { should have_many(:books).through(:book_authors) }
    it { should have_many(:favorites).dependent(:destroy) }
    it { should have_many(:episodes).through(:books) }
  end

  describe "validations" do
    subject { build(:author) }

    it { is_expected.to be_valid }

    it { should validate_presence_of(:name) }
    it do
      should validate_length_of(:name)
        .is_at_most(Settings.models.author.name.max_length)
    end

    it { should validate_presence_of(:intro) }
    it do
      should validate_length_of(:intro)
        .is_at_most(Settings.models.author.intro.max_length)
    end

    it { should validate_presence_of(:bio) }
    it { should validate_presence_of(:dob) }

    describe "custom validation #date_of_death_not_before_date_of_birth" do
      context "when dod is before dob" do
        before { subject.dod = subject.dob - 1.day }
        it "adds an error on :dod" do
          subject.validate
          expect(subject.errors[:dod]).to include("must be after the Date of Birth")
        end
      end

      context "when dod is after dob" do
        before { subject.dod = subject.dob + 1.day }
        it { is_expected.to be_valid }
      end
    end
  end

  describe "scopes" do
    describe ".sorted_by_name" do
      it "returns authors sorted by name in ascending order" do
        expect(Author.sorted_by_name).to eq([author1, author2])
      end
    end

    describe ".sorted_by_created" do
      it "returns authors sorted by created_at in descending order" do
        expect(Author.sorted_by_created).to eq([author2, author1])
      end
    end
  end
end
