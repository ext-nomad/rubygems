class CommentsController < ApplicationController
  def create
    @course = Course.friendly.find(params[:course_id])
    @lesson = Lesson.friendly.find(params[:lesson_id])
    @comment = Comment.new(comment_params)
    @comment.lesson_id = @lesson.id
    @comment.user = current_user

    if @comment.save
      redirect_to course_lesson_path(@course, @lesson), notice: 'Comment was successfully created.'
    else
      redirect_to course_lesson_path(@course, @lesson), alert: 'Something is missing.'
    end
  end

  def destroy
    @course = Course.friendly.find(params[:course_id])
    @lesson = Lesson.friendly.find(params[:lesson_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to course_lesson_path(@course, @lesson), notice: 'Comment was successfully deleted.'
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
