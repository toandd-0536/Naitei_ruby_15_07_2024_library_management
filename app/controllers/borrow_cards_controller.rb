class BorrowCardsController < ApplicationController
  before_action :redirect_unless_signed_in

  def index
    @cards = current_user.borrow_cards.recent_first
  end
end
