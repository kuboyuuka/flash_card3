class PostsController < ApplicationController

  def ranking
  end

  def new
    @post = Post.new(word: params[:word],mean: params[:mean])
    @post.tag
  end

  def create
      @post = current_user.tags.build(tag_params)
      @post.save
      if @post.save
          @tag.save
          redirect_to("/posts/index")
      else
        render:new
      end

  end

  def search
    @result = Post.ransack(params[:result])
    @posts = @result.result(distinct: true)
    
  end

  def index
      @posts = Post.all.order(created_at: :desc)
      @posts = Post.all.search(params[:search])
  end

  def edit
      @tag = Tag.find_by(id: params[:id])
      @post = Post.find_by(id: params[:id])
  end

  def update
      @tag = Tag.find_by(id: params[:id])
      @tag.tag = params[:tag]
      if @tag.save
          flash[:notice] = "タグを編集しました。"
          redirect_to("/posts/index")
      end
  end

  def show
      @tag = Tag.find_by(id: params[:id])
      @post = Post.find_by(id: @tag.id)
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    redirect_to("/posts/index")
  end
end
