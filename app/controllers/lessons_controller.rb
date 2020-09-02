class LessonsController < ApplicationController
  before_action :set_lesson, only: %i[show edit update destroy delete_video]

  def delete_video
    authorize @lesson, :edit?
    @lesson.video.purge
    @lesson.video_thumbnail.purge
    redirect_to edit_course_lesson_path(@course, @lesson), notice: 'Video successfully deleted'
  end

  def sort
    @course = Course.friendly.find(params[:course_id])
    lesson = Lesson.friendly.find(params[:lesson_id])
    authorize lesson, :edit?
    lesson.update(lesson_params)
    render body: nil
  end

  def index
    @lessons = Lesson.all
  end

  def show
    authorize @lesson
    current_user.view_lesson(@lesson)
    @lessons = @course.lessons.rank(:row_order)
    @comment = Comment.new
    @comments = @lesson.comments.order(created_at: :desc)
  end

  def new
    @lesson = Lesson.new
    @course = Course.friendly.find(params[:course_id])

    # authorize @lesson
  end

  def edit
    authorize @lesson
  end

  def create
    @lesson = Lesson.new(lesson_params)
    @course = Course.friendly.find(params[:course_id])
    @lesson.course_id = @course.id

    authorize @lesson

    respond_to do |format|
      if @lesson.save
        format.html { redirect_to course_lesson_path(@course, @lesson), notice: 'Lesson was successfully created.' }
        # format.json { render :show, status: :created, location: @lesson }
      else
        format.html { render :new }
        # format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @lesson

    respond_to do |format|
      if @lesson.update(lesson_params)
        format.html { redirect_to course_lesson_path(@course, @lesson), notice: 'Lesson was successfully updated.' }
        # format.json { render :show, status: :ok, location: @lesson }
      else
        format.html { render :edit }
        # format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @lesson

    @lesson.destroy
    respond_to do |format|
      format.html { redirect_to course_path(@course), notice: 'Lesson was successfully destroyed.' }
      # format.json { head :no_content }
    end
  end

  private

  def set_lesson
    @lesson = Lesson.friendly.find(params[:id])
    @course = Course.friendly.find(params[:course_id])
  end

  def lesson_params
    params.require(:lesson).permit(:title, :content, :row_order_position)
  end
end
