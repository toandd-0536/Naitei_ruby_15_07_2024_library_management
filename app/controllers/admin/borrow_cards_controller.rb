class Admin::BorrowCardsController < AdminController
  before_action :load_borrow_card, only: %i(borrow return history)

  def borrow_index
    @q = BorrowCard.joins(:borrow_books)
                   .merge(BorrowBook.pending_requests)
                   .ransack(params[:q])
    @borrow_cards = @q.result.includes(:user)
                      .distinct
                      .by_updated_desc
    @pagy, @borrow_cards = pagy(@borrow_cards, items: Settings.page)
    @breadcrumb_items = [{name: t(".borrow_index.title")}]
  end

  def return_index
    @q = BorrowCard.joins(:borrow_books)
                   .merge(BorrowBook.return_requests)
                   .ransack(params[:q])
    @borrow_cards = @q.result.includes(:user)
                      .distinct
                      .by_updated_desc
    @pagy, @borrow_cards = pagy(@borrow_cards, items: Settings.page)
    @breadcrumb_items = [{name: t(".return_index.title")}]
  end

  def history_index
    @q = BorrowCard.joins(:borrow_books)
                   .merge(BorrowBook.history_requests)
                   .ransack(params[:q])
    @borrow_cards = @q.result.includes(:user)
                      .distinct
                      .by_updated_desc
    @pagy, @borrow_cards = pagy(@borrow_cards, items: Settings.page)
    @breadcrumb_items = [{name: t(".history_index.title")}]
  end

  def borrow
    @q = @borrow_card.borrow_books.ransack(params[:q])
    @borrow_books = @q.result.includes(borrow_card: :user, episode: {book: []})
                      .pending
                      .by_updated_desc
    @pagy, @borrow_books = pagy(@borrow_books, items: Settings.page)
    @breadcrumb_items = [
      {name: t(".borrow_index.title"), url: borrow_admin_borrow_cards_path},
      {name: @borrow_card.id}
    ]
  end

  def return
    @q = @borrow_card.borrow_books.ransack(params[:q])
    @borrow_books = @q.result.includes(borrow_card: :user, episode: {book: []})
                      .return_requests
                      .by_updated_desc
    @pagy, @borrow_books = pagy(@borrow_books, items: Settings.page)
    @breadcrumb_items = [
      {name: t(".borrow_index.title"), url: return_admin_borrow_cards_path},
      {name: @borrow_card.id}
    ]
  end

  def history
    @q = @borrow_card.borrow_books.ransack(params[:q])
    @borrow_books = @q.result.includes(borrow_card: :user, episode: {book: []})
                      .history_requests
                      .by_updated_desc
    @pagy, @borrow_books = pagy(@borrow_books, items: Settings.page)
    @breadcrumb_items = [
      {name: t(".borrow_index.title"), url: history_admin_borrow_cards_path},
      {name: @borrow_card.id}
    ]
  end

  private

  def load_borrow_card
    @borrow_card = BorrowCard.find_by id: params[:id]
    return if @borrow_card

    flash[:danger] = t "message.borrow_cards.not_found"
    redirect_to admin_borrow_cards_path
  end
end
