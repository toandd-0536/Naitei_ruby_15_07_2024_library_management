module Admin::ApplicationHelper
  def object_new_path resource
    case resource
    when :user
      new_admin_user_path
    when :publisher
      new_admin_publisher_path
    when :author
      new_admin_author_path
    when :borrow_book
      new_admin_borrow_book_path
    when :category
      new_admin_category_path
    when :book
      new_admin_book_path
    when :episode
      new_admin_episode_path
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
    when Category
      edit_admin_category_path resource
    when Book
      edit_admin_book_path resource
    when Episode
      edit_admin_episode_path resource
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
    when Category
      admin_category_path resource
    when Book
      admin_book_path resource
    when Episode
      admin_episode_path resource
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
    when Publisher, Author, Category, Book, Episode
      true
    else
      false
    end
  end
end
