class ChaptersController < ApplicationController
  before_action :set_chapter, only: %i[edit update destroy sort]
  before_action :set_course, only: %i[new edit update destroy sort]

  def new
    @chapter = Chapter.new
    @chapter.course_id = @course.id
    authorize @chapter
  end

  def edit; end

  def create
    @chapter = Chapter.new(chapter_params)
    @chapter.course_id = @course.id

    authorize @chapter
    if @chapter.save
      redirect_to course_path(@course), notice: 'Chapter was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize @chapter
    if @chapter.update(chapter_params)
      redirect_to course_path(@course), notice: 'Chapter was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @chapter
    @chapter.destroy
    redirect_to course_path(@course), notice: 'Chapter was successfully destroyed.'
  end

  def sort
    authorize chapter, :edit?
    @chapter.update(chapter_params)
    render body: nil
  end

  private

  def set_chapter
    @chapter = Chapter.friendly.find(params[:id])
  end

  def set_course
    @course = Course.friendly.find(params[:course_id])
  end

  def chapter_params
    params.require(:chapter).permit(:title, :row_order_position)
  end
end
