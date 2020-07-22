# frozen_string_literal: true

class Course < ApplicationRecord
  validates :title,
            :short_description,
            :language,
            :level,
            :price,
            presence: true
  validates :description, presence: true, length: { minimum: 5 }

  has_rich_text :description
  belongs_to :user

  def to_s
    title
  end

  extend FriendlyId
  friendly_id :title, use: :slugged

  LANGUAGES = %i[English Russian Polish Spanish].freeze
  def self.languages
    LANGUAGES.map { |language| [language, language] }
  end

  LEVELS = %i[Beginner Intermediate Advanced].freeze
  def self.levels
    LEVELS.map { |level| [level, level] }
  end
  # hex_secured

  # friendly_id :generated_slug, use: :slugged
  # def generated_slug
  #   require 'securerandom'
  #   @random_slug ||= persistented? ? fiendly_id : SecureRandom.hex(4)
  # end

  # def to_s
  #   slug
  # end
end
