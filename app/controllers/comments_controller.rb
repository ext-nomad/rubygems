class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @lesson = Lesson.friendly.find(params[:lesson_id])
    @course = Course.friendly.find(params[:course_id])
    @comment.lesson_id = @lesson.id
    @comment.user = current_user

    if @comment.save
      redirect_to course_lesson_path(@course, @lesson), notice: 'Comment was successfully created.'
    else
      redirect_to course_lesson_path(@course, @lesson), alert: 'Something is missing.'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
