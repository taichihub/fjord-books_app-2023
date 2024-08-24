# frozen_string_literal: true

module CommentsHelper
  def form_url(commentable, comment)
    if comment.new_record?
      polymorphic_path([commentable, :comments])
    else
      case commentable
      when Book
        book_comment_path(commentable, comment)
      when Report
        report_comment_path(commentable, comment)
      end
    end
  end
end
