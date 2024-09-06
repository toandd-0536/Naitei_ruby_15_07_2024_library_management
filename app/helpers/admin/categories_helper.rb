module Admin::CategoriesHelper
  def category_options_for_select
    Category.all.map{|c| [c.name, c.id]}
  end
end
