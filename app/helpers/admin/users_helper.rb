module Admin::UsersHelper
  def can_delete_user? user
    current_user.admin? && !current_user?(user)
  end
end
