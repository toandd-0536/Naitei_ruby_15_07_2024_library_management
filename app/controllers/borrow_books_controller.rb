class BorrowBooksController < ApplicationController
  before_action :redirect_unless_signed_in, :set_borrow_book, :set_borrow_card
  before_action :check_status, only: :destroy

  def destroy
    if @borrow_card.borrow_books.count == Settings.card_item_min_delete
      @borrow_card.destroy
    else
      @borrow_book.destroy
    end
    flash[:success] = t "controllers.borrow_cards.success"
    redirect_back(fallback_location: borrow_cards_path)
  end

  private
  def set_borrow_card
    @borrow_card = BorrowCard.find params[:borrow_card_id]
  end

  def set_borrow_book
    @borrow_book = BorrowBook.find params[:id]
  end

  def check_status
    return if @borrow_book.pending?

    flash[:error] = t "controllers.borrow_cards.error"
    redirect_back(fallback_location: borrow_cards_path)
  end
end
