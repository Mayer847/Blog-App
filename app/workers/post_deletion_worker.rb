ass PostDeletionWorker
  include Sidekiq::Worker

  def perform(post_id)
    post = Post.find(post_id)
    post.destroy if post.created_at < 24.hours.ago
  end
end
