# frozen_string_literal: true

class User < ApplicationRecord
  has_many :courses, dependent: :nullify
  has_many :enrollments, dependent: :nullify
  has_many :user_lessons, dependent: :nullify
  has_many :comments, dependent: :nullify
  has_many :students, through: :courses, source: :enrollments

  rolify
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :trackable,
         :confirmable,
         :omniauthable, omniauth_providers: %i[google_oauth2 github vkontakte]

  validate :must_have_a_role, on: :update
  after_create :assign_default_role

  extend FriendlyId
  friendly_id :email, use: :slugged

  include PublicActivity::Model
  tracked only: %i[create destroy], owner: :itself

  after_create do
    UserMailer.new_user(self).deliver_later
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    if user
      user.name = access_token.info.name
      user.image = access_token.info.image

      user.provider = access_token.provider
      user.uid = access_token.uid

      user.token = access_token.credentials.token
      user.expires_at = access_token.credentials.expires_at
      user.expires = access_token.credentials.expires
      user.refresh_token = access_token.credentials.refresh_token

      user.save!
    else
      user = User.create(
        email: data['email'],
        password: Devise.friendly_token[0, 20],
        confirmed_at: Time.now
      )
    end
    user
  end

  def to_s
    email
  end

  def username
    email.split(/@/).first
  end

  def assign_default_role
    if User.count == 1
      add_role(:admin) if roles.blank?
      add_role(:student)
      add_role(:teacher)
    else
      add_role(:student) if roles.blank?
      add_role(:teacher)
    end
  end

  def online?
    updated_at > 2.minutes.ago
  end

  def buy_course(course)
    enrollments.create(course: course, price: course.price)
  end

  def view_lesson(lesson)
    if user_lessons.where(lesson: lesson).any?
      user_lessons.where(lesson: lesson).first.increment!(:impressions)
    else
      user_lessons.create(lesson: lesson)
    end
  end

  def calculate_course_income
    update_column :course_income, courses.map(&:income).sum
    update_column :balance, (course_income - enrollment_expenses)
  end

  def calculate_enrollment_expenses
    update_column :enrollment_expenses, enrollments.map(&:price).sum
    update_column :balance, (course_income - enrollment_expenses)
  end

  private

  def must_have_a_role
    errors.add(:roles, 'Must have at least one role') unless roles.any?
  end
end
