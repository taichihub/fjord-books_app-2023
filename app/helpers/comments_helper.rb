# frozen_string_literal: true

module CommentsHelper
  def form_url(commentable, comment)
    polymorphic_path([commentable, comment])
  end
end
