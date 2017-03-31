class PostsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create]
  before_action :find_posts, only: [:edit, :update, :destroy]
  def new
    @group = Group.find(params[:group_id])

    if current_user.is_member_of?(@group)
      @post = Post.new
    else
      redirect_to :back
      flash[:warning] = "请先收藏电影"
    end
  end

  def create
    @group = Group.find(params[:group_id])
    @post = Post.new(post_params)
    @post.group = @group
    @post.user = current_user

    if @post.save
      redirect_to group_path(@group)
    else
      render :new
    end
  end

  def edit

  end

  def update

    if @post.update(post_params)
      redirect_to account_posts_path, notice: "Update Success"
    else
      render :edit
    end
  end

  def destroy

    @post.destroy
    flash[:alert] = "文章已删除"

    redirect_to account_posts_path
  end


  private

  def post_params
    params.require(:post).permit(:content)
  end
  def find_posts
    @group = Group.find(params[:group_id])
    @post = Post.find(params[:id])
    @post.group = @group
    @post.user = current_user
  end
end
