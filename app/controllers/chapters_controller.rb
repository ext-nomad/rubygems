class ChaptersController < ApplicationController
  before_action :set_chapter, only: %i[edit update destroy sort]
  before_action :set_course, only: %i[new edit update destroy sort]

  def new
    @chapter = Chapter.new
  end

  def edit; end

  def create
    @chapter = Chapter.new(chapter_params)
    @chapter.course_id = @course.id

    if @chapter.save
      redirect_to course_path(@course), notice: 'Chapter was successfully created.'
    else
      render :new
    end
  end

  def update
    if @chapter.update(chapter_params)
      redirect_to course_path(@course), notice: 'Chapter was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @chapter.destroy
    redirect_to course_path(@course), notice: 'Chapter was successfully destroyed.'
  end

  def sort
    @chapter.update(chapter_params)
    render body: nil
  end

  private

  def set_chapter
    @chapter = Chapter.friendly.find(params[:chapter_id])
  end

  def set_course
    @course = Course.friendly.find(params[:course_id])
  end

  def chapter_params
    params.require(:chapter).permit(:title, :row_order_position)
  end
end
