module ApplicationHelper
  include Pagy::Frontend

  def without_field_error_proc
    original_field_error_proc = ActionView::Base.field_error_proc
    ActionView::Base.field_error_proc = proc{|html_tag, _| html_tag}
    yield
    ActionView::Base.field_error_proc = original_field_error_proc
  end

  def nav_link_to paths, class_active = "active", options = {}, &block
    paths = [paths] unless paths.is_a?(Array)
    active_class = paths.any?{|path| current_page?(path)} ? class_active : ""
    options[:class] = [options[:class], active_class].compact.join(" ")

    link_to paths.first, options, &block
  end
end
