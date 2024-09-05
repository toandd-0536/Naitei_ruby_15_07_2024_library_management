require "rails_helper"
require "pry"

RSpec.describe Admin::AuthorsController, type: :controller do
  let(:admin_user) { create(:user, role: :admin) }
  let(:non_admin_user) { create(:user, role: :user) }
  let(:guest_user) { nil }
  let!(:author) { create(:author) }

    let(:request_action) { get :index }

    it_behaves_like "admin controller"

  before do
    sign_in admin_user
  end

  describe "GET #index" do
    before { get :index }

    it "loads the authors and displays them" do
      expect(assigns(:q)).to be_a(Ransack::Search)
      expect(assigns(:authors)).to be_present
      expect(response).to render_template(:index)
    end

    it "loads breadcrumb items" do
      expect(assigns(:breadcrumb_items)).to be_an(Array)
    end

    context "when searching for authors" do
      let!(:search_author) { create(:author, name: "Search Author") }

      context "with a valid search query" do
        before do
          get :index, params: { q: { name_cont: "Search Author" } }
        end

        it "loads the search results" do
          expect(assigns(:q)).to be_a(Ransack::Search)
          expect(assigns(:authors)).to include(search_author)
          expect(response).to render_template(:index)
        end
      end

      context "with a search query that matches no authors" do
        before do
          get :index, params: { q: { name_cont: "Nonexistent Author" } }
        end

        it "loads no record" do
          expect(assigns(:q)).to be_a(Ransack::Search)
          expect(assigns(:authors)).to be_empty
          expect(response).to render_template(:index)
        end
      end
    end
  end

  describe "GET #show" do
    before { get :show, params: { id: author.id } }

    it "assigns the requested author" do
      expect(assigns(:author)).to eq(author)
      expect(response).to render_template(:show)
    end

    it "loads breadcrumb items" do
      expect(assigns(:breadcrumb_items)).to be_an(Array)
    end
  end

  describe "GET #new" do
    before { get :new }

    it "assigns a new author" do
      expect(assigns(:author)).to be_a_new(Author)
      expect(response).to render_template(:new)
    end

    it "loads breadcrumb items" do
      expect(assigns(:breadcrumb_items)).to be_an(Array)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      let(:valid_attributes) { attributes_for(:author) }

      it "creates a new author" do
        expect {
          post :create, params: { author: valid_attributes }
        }.to change(Author, :count).by(1)
      end

      it "redirects to the author show page with success flash message" do
        post :create, params: { author: valid_attributes }
        expect(response).to redirect_to(admin_author_path(Author.last))
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid attributes" do
      let(:invalid_attributes) { attributes_for(:author, name: nil) }

      it "does not create a new author" do
        expect {
          post :create, params: { author: invalid_attributes }
        }.not_to change(Author, :count)
      end

      it "renders the new template with error flash message" do
        post :create, params: { author: invalid_attributes }
        expect(response).to render_template(:new)
        expect(flash[:danger]).to be_present
      end
    end
  end

  describe "GET #edit" do
    before { get :edit, params: { id: author.id } }

    it "assigns the requested author for editing" do
      expect(assigns(:author)).to eq(author)
      expect(response).to render_template(:edit)
    end

    it "loads breadcrumb items" do
      expect(assigns(:breadcrumb_items)).to be_an(Array)
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      let(:valid_attributes) { { name: "Updated Name" } }

      it "updates the author" do
        patch :update, params: { id: author.id, author: valid_attributes }
        expect(author.reload.name).to eq("Updated Name")
      end

      it "redirects to the show page with success flash message" do
        patch :update, params: { id: author.id, author: valid_attributes }
        expect(response).to redirect_to(admin_author_path(author))
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid attributes" do
      let(:invalid_attributes) { { name: nil } }

      it "does not update the author" do
        patch :update, params: { id: author.id, author: invalid_attributes }
        expect(author.reload.name).not_to eq(nil) # The author name shouldn't change
      end

      it "renders the edit template with error flash message" do
        patch :update, params: { id: author.id, author: invalid_attributes }
        expect(response).to render_template(:edit)
        expect(flash[:danger]).to be_present
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the author" do
      author_to_delete = create(:author)
      expect {
        delete :destroy, params: { id: author_to_delete.id }
      }.to change(Author, :count).by(-1)
    end

    it "redirects to the index with success flash message" do
      author_to_delete = create(:author)
      delete :destroy, params: { id: author_to_delete.id }
      expect(response).to redirect_to(admin_authors_path)
      expect(flash[:success]).to be_present
    end
  end
end
