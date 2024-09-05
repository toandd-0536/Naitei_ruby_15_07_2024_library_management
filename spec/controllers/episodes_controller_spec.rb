require "rails_helper"
require "pry"

RSpec.describe EpisodesController, type: :controller do
  let(:author) {create(:author)}
  let(:category) {create(:category)}
  let(:user) {create(:user)}
  let(:book) {create(:book, :with_authors_and_categories)}
  let(:episode) {create(:episode, book: book)}
  let!(:other_ratings) {create_list(:rating, 3, episode: episode)}
  let!(:user_rating) {create(:rating, episode: episode, user: user)}
  let!(:borrow_card) {create(:borrow_card, user: user) }
  let!(:borrow_books) {create_list(:borrow_book, 10, borrow_card: borrow_card, episode: episode)}

  describe "GET #show" do
    it "assigns the correct book and episode", :focus do
      episode = create(:episode, book: book)
      get :show, params: {book_id: book.id, id: episode.id}

      expect(assigns(:book)).to eq(book)
      expect(assigns(:episode)).to eq(episode)
      expect(response).to render_template(:show)
    end
  end

  describe "GET #all" do
    before do
      get :all, params: {q: {}}
    end

    it "loads search values and paginates episodes" do
      expect(assigns(:books)).to eq(Book.sorted_by_name)
      expect(assigns(:cats)).to eq(Category.sorted_by_name)
      expect(assigns(:publishers)).to eq(Publisher.sorted_by_name)
      expect(assigns(:authors)).to eq(Author.sorted_by_name)
      expect(assigns(:episodes_search)).to eq(Episode.ransack({}).result(distinct: true))
      expect(assigns(:episodes)).to_not be_nil
    end
  end

  describe "POST #add_to_cart" do
    context "when user is not logged in" do
      it "redirects to sign in page if user is not logged in" do
        post :add_to_cart, params: {book_id: book.id, id: episode.id}

        expect(flash[:alert]).to eq(I18n.t("controllers.episodes.error_login"))
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in but cannot borrow the episode" do
      before do
        sign_in user
        create_list(:borrow_book, 10, borrow_card: borrow_card, episode: episode, status: :pending)
        request.env["HTTP_REFERER"] = book_episode_path(book, episode, locale: I18n.locale)
      end

      context "when user is not activated" do
        it "fails and shows error about activation" do
          user.update(activated: false)
          post :add_to_cart, params: {book_id: book.id, id: episode.id}

          expect(flash[:error]).to include(I18n.t("controllers.episodes.error_active"))
          expect(response).to redirect_to(book_episode_path(book, episode, locale: I18n.locale))
        end
      end

      context "when user is blacklisted" do
        it "fails and shows error about being blacklisted" do
          user.update(blacklisted: true)

          post :add_to_cart, params: {book_id: book.id, id: episode.id}

          expect(flash[:error]).to include(I18n.t("controllers.episodes.error_blacklist"))
          expect(response).to redirect_to(book_episode_path(book, episode, locale: I18n.locale))
        end
      end

      context "when the episode is already in the cart" do
        it "fails and shows error about episode already in the cart" do
          user.carts.create(episode: episode)

          post :add_to_cart, params: {book_id: book.id, id: episode.id}

          expect(flash[:error]).to include(I18n.t("controllers.episodes.error_exists"))
          expect(response).to redirect_to(book_episode_path(book, episode, locale: I18n.locale))
        end
      end

      context "when episode quantity is zero" do
        it "fails and shows error about episode quantity" do
          episode.update(qty: 0)

          post :add_to_cart, params: {book_id: book.id, id: episode.id}
          expect(flash[:error]).to include(I18n.t("controllers.episodes.error_qty"))
          expect(response).to redirect_to(book_episode_path(book, episode, locale: I18n.locale))
        end
      end

      context "when user has reached borrowing limit" do
        it "fails and shows error about reaching borrowing limit" do
          post :add_to_cart, params: {book_id: book.id, id: episode.id}

          expect(flash[:error]).to include(I18n.t("controllers.episodes.error_max"))

          expect(response).to redirect_to(book_episode_path(book, episode, locale: I18n.locale))
        end
      end
    end
  end
end
