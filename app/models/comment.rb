class Comment < ApplicationRecord
  belongs_to :user, counter_cache: true
  belongs_to :lesson, counter_cache: true
  has_rich_text :content

  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  validates :content, presence: true
end
