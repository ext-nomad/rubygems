# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable

  rolify

  def to_s
    email
  end

  def username
    email.split(/@/).first
  end

  has_many :courses

  after_create :assign_default_role

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

  validate :must_have_a_role, on: :update

  private

  def must_have_a_role
    errors.add(:roles, 'Must have at least one role') unless roles.any?
  end
end
