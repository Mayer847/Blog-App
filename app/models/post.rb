class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  validates :title, :body, :tags, presence: true

  after_create :schedule_deletion

  private

  def schedule_deletion
    PostDeletionJob.perform_in(24.hours, self.id)
  end
end
