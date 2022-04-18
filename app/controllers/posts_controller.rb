class PostsController < ApplicationController

    def ranking
    end
  
    def new
      @post = Post.new
    end
  
    def create
        @post = Post.new(post_params)
        @post.user_id=current_user.id
        tag_list=params[:name].split(',')
        if @post.save
          @post.save_tag(tag_list)
          redirect_to("/posts/index")
        else
          render:new
        end
    end

    def create_tag
      @tag = Tag.new(name: params[:name])
      @postag.tag_id = @tag.id
      if @tag.save
        redirect_to("/posts/tagmaster")
      else
        render:tag_new
      end
    end

    def tag
      @tags = Tag.pluck(:name)
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
        @tag = Tag.all
    end
  
    def edit
        @tag = Tag.find_by(id: params[:id])
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
        @user = @post.user
        @postag.tag_id = @tag.id
        @tag = Tag.find_by(id: @postag.id)
    end
  
    def destroy
      @post = Post.find_by(id: params[:id])
      @post.destroy
      redirect_to("/posts/index")
    end
  end
  