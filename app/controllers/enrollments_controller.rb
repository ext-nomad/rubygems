class EnrollmentsController < ApplicationController
  skip_before_action :authenticate_user!, only: :certificate
  before_action :set_enrollment, only: %i[show edit update destroy certificate]
  before_action :set_course, only: %i[new create]

  def index
    @ransack_path = enrollments_path
    @q = Enrollment.ransack(params[:q])
    @pagy, @enrollments = pagy(@q.result.includes(:user))
    authorize @enrollments
  end

  def my_students
    @ransack_path = my_students_enrollments_path
    @q = Enrollment.joins(:course).where(courses: { user: current_user }).ransack(params[:q])
    @pagy, @enrollments = pagy(@q.result.includes(:user))
    render 'index'
  end

  def certificate
    authorize @enrollment, :certificate?

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "#{@enrollment.course.title}, #{@enrollment.user.email}",
               page_size: 'A4',
               template: 'enrollments/certificate.pdf.haml'
      end
    end
  end

  def show; end

  def new
    @enrollment = Enrollment.new
  end

  def edit
    authorize @enrollment
  end

  def create
    @enrollment = current_user.buy_course(@course)

    if @course.price.positive?
      @amount = (@course.price * 100).to_i

      customer = Stripe::Customer.create(
        email: params[:stripeEmail],
        source: params[:stripeToken]
      )

      charge = Stripe::Charge.create(
        customer: customer.id,
        amount: @amount,
        description: 'RubyGems Premium Content',
        currency: 'usd'
      )

      @enrollment = current_user.buy_course(@course)
      redirect_to course_path(@course), notice: 'You are enrolled!'
    end

    redirect_to course_path(@course), notice: 'You are enrolled!'

    EnrollmentMailer.student_enrollment(@enrollment).deliver_later
    EnrollmentMailer.teacher_enrollment(@enrollment).deliver_later
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_course_enrollment_path(@course)
  end

  def update
    authorize @enrollment

    if @enrollment.update(enrollment_params)
      redirect_to @enrollment, notice: 'Enrollment was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @enrollment.destroy
    authorize @enrollment

    redirect_to enrollments_url, notice: 'Enrollment was successfully destroyed'
  end

  private

  def set_course
    @course = Course.friendly.find(params[:course_id])
  end

  def set_enrollment
    @enrollment = Enrollment.friendly.find(params[:id])
  end

  def enrollment_params
    params.require(:enrollment).permit(:rating, :review)
  end
end
