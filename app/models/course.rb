# frozen_string_literal: true

class Course < ApplicationRecord
  belongs_to :user, counter_cache: true
  has_many :lessons, dependent: :destroy
  has_many :enrollments, dependent: :restrict_with_error
  has_many :user_lessons, through: :lessons
  has_many :course_tags, dependent: :destroy
  has_many :tags, through: :course_tags
  has_one_attached :avatar

  has_rich_text :description

  validates :title,
            :short_description,
            :language,
            :level,
            :price,
            presence: true
  validates :description, presence: true, length: { minimum: 5 }
  validates :title, uniqueness: true
  validates :avatar, presence: true, on: :update
  validates :avatar,
            content_type: %w[image/png image/jpg image/jpeg],
            size: { less_than: 500.kilobytes,
                    message: 'size shoud be under 500 kilobytes' }

  extend FriendlyId
  friendly_id :title, use: :slugged

  scope :popular, -> { order(enrollments_count: :desc, created_at: :desc).limit(3) }
  scope :top_rated, -> { order(average_rating: :desc, created_at: :desc).limit(3) }
  scope :latest, -> { all.order(created_at: :desc).limit(3) }
  scope :purchased, -> { joins(:enrollments).order(created_at: :desc) }
  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }
  scope :approved, -> { where(approved: true) }
  scope :unapproved, -> { where(approved: false) }

  LANGUAGES = %i[English Russian Polish Spanish].freeze
  LEVELS = %i[Beginner Intermediate Advanced].freeze

  def self.languages
    LANGUAGES.map { |language| [language, language] }
  end

  def self.levels
    LEVELS.map { |level| [level, level] }
  end

  def to_s
    title
  end

  def update_rating
    if enrollments.any? && enrollments.where.not(rating: nil).any?
      update_column :average_rating, enrollments.average(:rating).round(2).to_f
    else
      update_column :average_rating, 0
    end
  end

  def progress(user)
    (user_lessons.where(user: user).count / lessons_count.to_f) * 100 unless lessons_count.zero?
  end

  # hex_secured_slug
  # friendly_id :generated_slug, use: :slugged
  # def generated_slug
  #   require 'securerandom'
  #   @random_slug ||= persistented? ? friendly_id : SecureRandom.hex(4)
  # end
  # def to_s
  #   slug
  # end

  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  def bought(user)
    enrollments.where(user_id: [user.id], course_id: [id]).empty?
  end
end
