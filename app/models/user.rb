# frozen_string_literal: true

class User < ApplicationRecord
  has_many :courses, dependent: :nullify
  has_many :enrollments, dependent: :nullify
  has_many :user_lessons, dependent: :nullify

  rolify
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :trackable,
         :confirmable

  validate :must_have_a_role, on: :update
  after_create :assign_default_role

  extend FriendlyId
  friendly_id :email, use: :slugged

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
    user_lessons.create(lesson: lesson) unless user_lessons.where(lesson: lesson).any?
  end

  private

  def must_have_a_role
    errors.add(:roles, 'Must have at least one role') unless roles.any?
  end
end
