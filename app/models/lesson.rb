class Lesson < ApplicationRecord
  belongs_to :course, counter_cache: true
  has_many :user_lessons, dependent: :destroy
  has_rich_text :content
  validates :title,
            :content,
            :course,
            presence: true

  extend FriendlyId
  friendly_id :title, use: :slugged

  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  include RankedModel
  ranks :row_order, with_same: :course_id

  def to_s
    title
  end

  def viewed(user)
    user_lessons.where(user: user).present?
    # user_lessons.where(user_id: [user.id], lesson_id: [id]).present?
  end

  def prev
    course.lessons.where('row_order < ?', row_order).order(:row_order).last
  end

  def next
    course.lessons.where('row_order > ?', row_order).order(:row_order).first
  end
end
