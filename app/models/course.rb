# frozen_string_literal: true

class Course < ApplicationRecord
  belongs_to :user, counter_cache: true
  has_many :chapters, dependent: :destroy, inverse_of: :course
  has_many :lessons, dependent: :destroy, inverse_of: :course
  has_many :enrollments, dependent: :restrict_with_error
  has_many :user_lessons, through: :lessons
  has_many :course_tags, dependent: :destroy
  has_many :tags, through: :course_tags

  has_rich_text :description
  has_one_attached :avatar

  accepts_nested_attributes_for :chapters,
                                reject_if: :all_blank,
                                allow_destroy: true
  accepts_nested_attributes_for :lessons,
                                reject_if: :all_blank,
                                allow_destroy: true

  validates :title,
            :short_description,
            :language,
            :level,
            :price,
            presence: true
  validates :description, presence: true, length: { minimum: 5 }
  validates :title, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0, less_than: 999 }
  validates :avatar, presence: true, on: :update
  validates :avatar,
            content_type: %w[image/png image/jpg image/jpeg],
            size: { less_than: 500.kilobytes,
                    message: 'size should be under 500 kilobytes' }

  extend FriendlyId
  friendly_id :title, use: :slugged

  scope :popular, -> { order(enrollments_count: :desc, created_at: :desc).limit(3) }
  scope :top_rated, -> { order(average_rating: :desc, created_at: :desc).limit(3) }
  scope :latest, -> { all.order(created_at: :desc).limit(3) }
  scope :learning, -> { joins(:enrollments).order(created_at: :desc) }
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

  def calculate_income
    update_column :income, enrollments.map(&:price).sum
    user.calculate_course_income
  end

  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  def bought(user)
    enrollments.where(user_id: [user.id], course_id: [id]).present?
  end

  def similar_courses
    self.class
        .joins(:tags)
        .where.not(id: id)
        .where(tags: { id: tags.ids })
        .select(
          'courses.*',
          'COUNT(tags.*) AS tags_in_common'
        )
        .group(:id)
        .order(tags_in_common: :desc)
  end
end
