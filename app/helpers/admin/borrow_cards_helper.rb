module Admin::BorrowCardsHelper
  def path_for_action action_type, borrow_card
    case action_type
    when :return
      return_admin_borrow_card_path(borrow_card)
    when :borrow
      borrow_admin_borrow_card_path(borrow_card)
    when :history
      history_admin_borrow_card_path(borrow_card)
    end
  end
end
