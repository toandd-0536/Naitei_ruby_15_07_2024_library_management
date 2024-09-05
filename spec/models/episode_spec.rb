require "rails_helper"

RSpec.describe Episode, type: :model do
  let!(:author) { create(:author) }
  let!(:category) { create(:category) }
  let!(:publisher) { create(:publisher) }
  let!(:book) { create(:book, publisher: publisher, authors: [author], categories: [category]) }
  let!(:episode1) { create(:episode, name: "Episode A", book: book) }
  let!(:episode2) { create(:episode, name: "Episode B", book: book) }
  let!(:rating1) { create(:rating, episode: episode1, rating: 3) }
  let!(:rating2) { create(:rating, episode: episode1, rating: 4) }
  let!(:rating3) { create(:rating, episode: episode2, rating: 5) }

  describe "associations" do
    it { should belong_to(:book) }
    it { should have_one(:publisher).through(:book) }
    it { should have_many(:book_categories).through(:book) }
    it { should have_many(:categories).through(:book_categories) }
    it { should have_many(:book_authors).through(:book) }
    it { should have_many(:authors).through(:book_authors) }
    it { should have_many(:carts).dependent(:destroy) }
    it { should have_many(:borrow_books).dependent(:destroy) }
    it { should have_many(:favorites).dependent(:destroy) }
    it { should have_many(:ratings).dependent(:destroy) }
    it { should have_many(:users).through(:carts) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    
    it do
      should validate_length_of(:name)
        .is_at_most(Settings.models.episode.name_max)
    end

    it { should validate_presence_of(:qty) }

    it do
      should validate_numericality_of(:qty)
        .only_integer
        .is_greater_than_or_equal_to(Settings.models.episode.min)
    end

    it do
      should validate_length_of(:intro)
        .is_at_most(Settings.models.episode.name_max)
    end

    it { should validate_presence_of(:content) }

    it do
      should validate_numericality_of(:compensation_fee)
        .only_integer
        .is_greater_than_or_equal_to(Settings.models.episode.min)
    end
  end

  describe "scopes" do
    describe ".sorted_by_name" do
      it "returns episodes sorted by name in ascending order" do
        expect(Episode.sorted_by_name).to eq([episode1, episode2])
      end
    end

    describe ".sorted_by_created" do
      it "returns episodes sorted by creation date in descending order" do
        expect(Episode.sorted_by_created).to eq([episode2, episode1])
      end
    end

    describe ".search_by_name" do
      it "returns episodes matching the keyword" do
        expect(Episode.search_by_name("Episode A")).to include(episode1)
        expect(Episode.search_by_name("Episode A")).to_not include(episode2)
      end
    end

    describe ".trend_episodes" do
      let!(:favorite) { create(:favorite, favoritable: episode1) }

      it "returns the most favored episodes" do
        expect(Episode.trend_episodes).to eq([episode1])
      end
    end

    describe ".most_reads" do
      it "returns episodes sorted by highest average rating" do
        expect(Episode.most_reads).to eq([episode2, episode1])
      end
    end

    describe ".for_category" do
      it "returns episodes for a given category" do
        expect(Episode.for_category(category.id)).to include(episode1)
      end
    end

    describe ".by_book" do
      it "returns episodes for a given book" do
        expect(Episode.by_book(book.id)).to include(episode1)
      end
    end

    describe ".by_publisher" do
      it "returns episodes for a given publisher" do
        expect(Episode.by_publisher(publisher.id)).to include(episode1)
      end
    end

    describe ".by_author" do
      it "returns episodes for a given author" do
        expect(Episode.by_author(author.id)).to include(episode1)
      end
    end

    describe ".by_category" do
      it "returns episodes for a given category" do
        expect(Episode.by_category(category.id)).to include(episode1)
      end
    end
  end

  describe "#average_rating" do
    it "calculates the correct average rating" do
      expect(episode1.average_rating).to eq(3.5)
      expect(episode2.average_rating).to eq(5.0)
    end

    it "returns 0 if there are no ratings" do
      episode = create(:episode, book: book)
      expect(episode.average_rating).to eq(0)
    end
  end

  describe ".search" do
    it "searches episodes by various parameters" do
      expect(Episode.search(book_id: book.id)).to include(episode1, episode2)
      expect(Episode.search(publisher_id: publisher.id)).to include(episode1, episode2)
      expect(Episode.search(author_id: author.id)).to include(episode1, episode2)
      expect(Episode.search(category_id: category.id)).to include(episode1, episode2)
    end
  end
end
