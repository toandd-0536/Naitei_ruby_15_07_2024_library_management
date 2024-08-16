module Admin::BorrowBookMailerHelper
  def status_change_message new_status, old_status = nil, episode = nil
    case new_status
    when "confirm"
      t ".confirmed"
    when "cancel"
      t ".cancelled"
    when "overdue"
      t ".overdue_inactivated"
    when "returned"
      if old_status == "confirm"
        t ".returned_books"
      elsif old_status == "overdue"
        t ".overdue_returned_books"
      end
    when "lost"
      t(".lost_inactivated", compensation_fee: episode.compensation_fee)
    end
  end
end
