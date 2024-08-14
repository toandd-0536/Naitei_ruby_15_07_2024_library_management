module ApplicationHelper
  include Pagy::Frontend
<<<<<<< HEAD

  def without_field_error_proc
    original_field_error_proc = ActionView::Base.field_error_proc
    ActionView::Base.field_error_proc = proc{|html_tag, _| html_tag}
    yield
    ActionView::Base.field_error_proc = original_field_error_proc
  end
=======
>>>>>>> master
end
