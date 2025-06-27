class TravelTip < ApplicationRecord
  has_many :videos, dependent: :destroy

  validates :city, presence: true, uniqueness: true
  validates :marathon, presence: true
  validates :source_url, presence: true, format: { with: URI::regexp, message: "must be a valid URL" }
  
  # Sentiment can only be positive or negative
  validates :sentiment, inclusion: { in: %w[positive negative], allow_nil: true }

  # Callback to ensure city names are standardized
  before_validation :normalize_city_name

  private

  def normalize_city_name
    self.city = city.strip.titleize if city.present?
  end
end
