class PostsController < ApplicationController
  before_action :authenticate_user
  before_action :set_post, only: [:show, :update, :destroy]

  def index
    @posts = Post.all
    render json: @posts
  end

  def show
    render json: @post
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      render json: @post, status: :created
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @post.user == current_user && @post.update(post_params)
      render json: @post
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @post.user == current_user
      @post.destroy
      head :no_content
    else
      render json: { errors: ['Not authorized'] }, status: :unauthorized
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :tags)
  end

  def authenticate_user
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    decoded = JWT.decode(token, 'your_secret_key', true, algorithm: 'HS256')
    @current_user = User.find(decoded[0]['user_id'])
  rescue
    render json: { errors: ['Not authenticated'] }, status: :unauthorized
  end
end
