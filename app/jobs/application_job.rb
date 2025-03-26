class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
  queue_as :default
  
  
  def perform(post_id)
    post = Post.find_by(id: post_id)
    post.destroy if post && post.created_at < 24.hours.ago
  end
end
