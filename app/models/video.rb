class Video < ApplicationRecord
  belongs_to :travel_tip

  validates :script, presence: true
  validates :status, presence: true, inclusion: { in: %w[pending approved produced uploaded failed] }
  validates :youtube_id, uniqueness: true, allow_nil: true
  validates :video_path, presence: true, if: -> { status.in?(%w[produced uploaded]) }
  validates :thumbnail_path, presence: true, if: -> { status.in?(%w[produced uploaded]) }

  # Scopes for easy querying
  scope :pending, -> { where(status: 'pending') }
  scope :approved, -> { where(status: 'approved') }
  scope :produced, -> { where(status: 'produced') }
  scope :uploaded, -> { where(status: 'uploaded') }
  scope :failed, -> { where(status: 'failed') }

  # State machine transitions
  def approve!
    update!(status: 'approved')
  end

  def mark_as_produced!
    update!(status: 'produced')
  end

  def mark_as_uploaded!
    update!(status: 'uploaded')
  end

  def mark_as_failed!
    update!(status: 'failed')
  end
end
