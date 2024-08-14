module Admin::ApplicationHelper
  def object_edit_path resource
    case resource
    when User
      edit_admin_user_path resource
    else
      raise "Unknown model: #{resource.class.name}"
    end
  end

  def object_path resource
    case resource
    when User
      admin_user_path resource
    else
      raise "Unknown model: #{resource.class.name}"
    end
  end

  def can_delete? resource
    case resource
    when User
      can_delete_user? resource
    else
      false
    end
  end
end
