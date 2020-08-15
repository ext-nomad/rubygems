class Lesson < ApplicationRecord
  belongs_to :course, counter_cache: true
  has_many :user_lessons
  has_rich_text :content
  validates :title,
            :content,
            :course,
            presence: true

  extend FriendlyId
  friendly_id :title, use: :slugged

  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  def to_s
    title
  end

  def viewed(user)
    user_lessons.where(user: user).present?
    # user_lessons.where(user_id: [user.id], lesson_id: [id]).present?
  end
end
