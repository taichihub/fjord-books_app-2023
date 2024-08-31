# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable
  before_action :set_comment, only: %i[edit update destroy]
  before_action :check_user_permission, only: %i[edit update destroy]

  def new
    @comment = @commentable.comments.new
  end

  def create
    @comment = @commentable.comments.build(comment_params)
    if @comment.save
      redirect_to @commentable
    else
      render :new
    end
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      redirect_to @commentable
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
    redirect_to @commentable
  end

  private

  def set_commentable
    @commentable = find_commentable
  end

  def set_comment
    @comment = @commentable.comments.find(params[:id])
  end

  def find_commentable
    params.each do |name, value|
      return Book.find(value) if name == 'book_id'
      return Report.find(value) if name == 'report_id'
    end
    nil
  end

  def comment_params
    params.require(:comment).permit(:content).merge(user: current_user)
  end

  def check_user_permission
    return redirect_to @commentable if current_user.id != @comment.user_id
  end
end
