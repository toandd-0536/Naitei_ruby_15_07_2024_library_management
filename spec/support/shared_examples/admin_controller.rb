RSpec.shared_examples "admin controller" do
  before do
    sign_in current_user if current_user.present?
    allow(controller).to receive(:logged_in?).and_return(current_user.present?)
    allow(controller).to receive(:current_user).and_return(current_user) if current_user.present?
  end

  context "when user is a guest" do
    let(:current_user) { guest_user }
    before { request_action }

    it "redirects to the login page" do
      expect(response).to redirect_to(new_user_session_url)
    end

    it "sets a flash danger message" do
      expect(flash[:danger]).to be_present
    end
  end

  context "when user is not an admin" do
    let(:current_user) { non_admin_user }
    before { request_action }

    it "redirects to the root path" do
      expect(response).to redirect_to(root_path)
    end

    it "sets an access denied flash message" do
      expect(flash[:danger]).to be_present
    end
  end

  context "when user is an admin" do
    let(:current_user) { admin_user }
    before { request_action }

    it "allows access" do
      expect { request_action }.not_to raise_error
    end
  end
end
