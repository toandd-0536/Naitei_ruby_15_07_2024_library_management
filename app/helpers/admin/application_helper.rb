module Admin::ApplicationHelper
  def object_new_path resource
    case resource
    when :user
      new_admin_user_path
    when :publisher
      new_admin_publisher_path
    when :author
      new_admin_author_path
    else
      raise "Unknown model: #{resource}"
    end
  end

  def object_edit_path resource
    case resource
    when User
      edit_admin_user_path resource
    when Publisher
      edit_admin_publisher_path resource
    when Author
      edit_admin_author_path resource
    else
      raise "Unknown model: #{resource.class.name}"
    end
  end

  def object_path resource
    case resource
    when User
      admin_user_path resource
    when Publisher
      admin_publisher_path resource
    when Author
      admin_author_path resource
    else
      raise "Unknown model: #{resource.class.name}"
    end
  end

  def active_nav_item? path_segment
    request.path.match?(Regexp.new("/admin/#{path_segment}"))
  end

  def can_delete? resource
    case resource
    when User
      can_delete_user? resource
    when Publisher, Author
      true
    else
      false
    end
  end
end