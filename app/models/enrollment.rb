class Enrollment < ApplicationRecord
  belongs_to :course, counter_cache: true
  belongs_to :user, counter_cache: true

  validates :user, :course, presence: true

  validates_presence_of :rating, if: :review?
  validates_presence_of :review, if: :rating?

  validates_uniqueness_of :user_id, scope: :course_id
  validates_uniqueness_of :course_id, scope: :user_id

  validate :cant_subscribe_to_own_course

  scope :pending_review, -> { where(rating: [0, nil, ''], review: [0, nil, '']) }
  scope :reviewed, -> { where.not(review: [0, nil, '']) }
  scope :latest_good_reviews, -> { reviewed.order(rating: :desc, created_at: :desc).limit(3) }

  extend FriendlyId
  friendly_id :to_s, use: :slugged

  def to_s
    user.to_s + ' ' + course.to_s
  end

  after_save do
    course.update_rating unless rating.nil? || rating.zero?
  end

  after_destroy do
    course.update_rating
  end

  after_create :calculate_balance
  after_destroy :calculate_balance

  def calculate_balance
    course.calculate_income
    user.calculate_enrollment_expenses
  end

  protected

  def cant_subscribe_to_own_course
    if new_record? && user_id.present? && (user_id == course.user_id)
      errors.add(:base, 'You can not subscribe to your own course')
    end
  end
end
