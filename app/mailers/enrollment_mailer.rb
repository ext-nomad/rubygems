class EnrollmentMailer < ApplicationMailer
  def student_enrollment(enrollment)
    @enrollment = enrollment

    mail(
      to: @enrollment.user.email,
      subject: "You have enrolled to: #{@enrollment.course}"
    )
  end

  def teacher_enrollment(enrollment)
    @enrollment = enrollment

    mail(
      to: @enrollment.course.user.email,
      subject: "You have a new student in this course: #{@enrollment.course}"
    )
  end
end
