class PostsController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:index]
  before_action :set_post, :only => [:show, :edit, :update, :destroy, :like]

  # GET /posts or /posts.json
  def index
    @posts = Post.order(created_at: :desc).paginate(page: params[:page], per_page: 6)

  end

  # GET /posts/1 or /posts/1.json
  def show
    @comment = Comment.new
    @comment.post_id = @post.id

  end

  def like
    if current_user.voted_for? @post
      @post.unliked_by current_user
    else
      @post.liked_by current_user
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    if @post.user_id == current_user.id
    else
      redirect_to root_path, notice: "У вас нет прав!"
    end
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: " Пост успешно создан." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    if @post.user_id == current_user.id
      respond_to do |format|
        if @post.update(post_params)
          format.html { redirect_to @post, notice: "Пост успешно обновлен." }
          format.json { render :show, status: :ok, location: @post }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path, notice: "У вас нет прав!"
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    if @post.user_id == current_user.id
      @post.destroy
      respond_to do |format|
        format.html { redirect_to posts_url, notice: "Пост удален." }
        format.json { head :no_content }
      end
    else
      redirect_to root_path, notice: "У вас нет прав!"
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
    @tag = Tag.find(params[:id])

  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :content, :tag_list)
  end
end