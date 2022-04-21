class PostsController < ApplicationController

    def ranking
    end
  
    def new
      @post_form = PostForm.new
    end
  
    def create
      @post_form = PostForm.new(post_params)
      @post.user_id = @current_user.id
      if @post_form.save
         redirect_to("/posts/index")
      else
        render:new
      end
    end

    def post_params
      params.require(:post_form).permit(:word, :mean, :user_id, :synonym)
    end
  
    def post_params
      params.require(:post).permit(:word, tags_attributes: [:tag])
    end
  
    def search
      @result = Post.ransack(params[:result])
      @posts = @result.result(distinct: true)
      
    end
  
    def index
      @posts = Post.all.order(created_at: :desc)
      @posts = Post.all.search(params[:search])
      @tags = Tag.pluck(:name)
    end
  
    def edit
      @tags = Tag.all
      @post = Post.find_by(id: params[:id])
    end
  
    def update
      @tag = Tag.find_by(id: params[:id])
      @tag.name = params[:name]
      if @tag.save
         flash[:notice] = "タグを編集しました。"
         redirect_to("/posts/index")
      end
    end
  
    def show
      @post = Post.find_by(id: params[:id])
      @user = @post.user_id
      @postag = PostTag.find_by(id: @post.id)
      @tag = Tag.find_by(id: params[:id])
    end
  
    def destroy
      @post = Post.find_by(id: params[:id])
      @post.destroy
      redirect_to("/posts/index")
    end
  end
  