module Admin::AuthorsHelper
  def author_image author
    if author.thumb_img.attached?
      author.thumb_img
    elsif author.thumb.present?
      author.thumb
    else
      "user.png"
    end
  end
end
