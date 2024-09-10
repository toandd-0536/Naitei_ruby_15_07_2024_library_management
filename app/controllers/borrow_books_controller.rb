class BorrowBooksController < ApplicationController
  before_action :redirect_unless_signed_in
  before_action :set_borrow_book, only: %i(destroy update_reason)
  before_action :set_borrow_card, :check_status, only: :destroy
  before_action :get_borrow_books, only: :send_request

  def destroy
    if @borrow_card.borrow_books.count == Settings.card_item_min_delete
      @borrow_card.destroy
    else
      @borrow_book.destroy
    end
    flash[:success] = t "controllers.borrow_cards.success"
    redirect_back(fallback_location: borrow_cards_path)
  end

  def send_request; end

  def update_reason
    if params[:lost_reason].blank?
      flash[:error] = t "controllers.borrow_books.lost_reason_blank"
    elsif @borrow_book.update borrow_book_params
      flash[:success] = t "controllers.borrow_books.lost_updated"
    else
      flash[:error] = t "controllers.borrow_books.update_failed"
    end
    redirect_back(fallback_location: root_path)
  end

  private
  def set_borrow_card
    @borrow_card = current_user.borrow_cards.find params[:borrow_card_id]
  end

  def set_borrow_book
    if params[:id].blank?
      flash[:error] = t "controllers.borrow_books.id_blank"
      redirect_back(fallback_location: borrow_cards_path) and return
    end
    @borrow_book = current_user.borrow_books.find params[:id]
  end

  def check_status
    return if @borrow_book.pending?

    flash[:error] = t "controllers.borrow_cards.error"
    redirect_back(fallback_location: borrow_cards_path)
  end

  def get_borrow_books
    statuses = [BorrowBook.statuses[:confirm], BorrowBook.statuses[:overdue]]
    list = current_user.borrow_books_by_status statuses
    @borrow_books = list.sorted_by_created
  end

  def borrow_book_params
    params.permit :lost_reason
  end
end
