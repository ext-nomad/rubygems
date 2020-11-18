class Chapter < ApplicationRecord
  validates :course, :title, presence: true
  validates :title, length: { minimum: 3, maximum: 100 }
  validates_uniqueness_of :title, scope: :course_id

  belongs_to :course, counter_cache: true
  has_many :lessons, dependent: :destroy, inverse_of: :chapter

  extend FriendlyId
  friendly_id :title, use: :slugged

  include RankedModel
  ranks :row_order, with_same: :course_id

  def to_s
    title
  end
end
