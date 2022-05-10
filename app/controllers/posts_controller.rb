class PostsController < ApplicationController

  require "csv"

    def ranking
    end
  
    def new
      @post = Post.new
      @synonym = @post.synonyms.build
      @tags = Tag.all
      @postags = PostTag.all
    end
  
    def create
      @post = Post.new(post_params)
      @post.user_id = @current_user.id
      if @post.save
         @postag = PostTag.new(tag_id: params[:post][:tag_id],post_id: @post.id)
         @postag.save
         redirect_to("/posts/index")
      else
        p @post.errors.full_messages
        render("posts/new")
      end
    end

    def post_params
      params.require(:post).permit(
        :word, 
        :mean, 
        :user_id, 
        :tag_id, 
        :image,
        synonyms_attributes: [:synonym]
      )
    end

    def search
        @posts = Post.search(params[:keyword])
        @synonyms = Synonym.search(params[:keyword])
        @tags = Tag.search(params[:keyword])
    end
  
    def index
      @posts = Post.all.order(created_at: :desc)
      @postags = PostTag.all
      @synonyms = Synonym.all
    end
  
    def edit
      @tags = Tag.all
      @post = Post.find_by(id: params[:id])
      @synonym = Synonym.find_by(post_id: params[:id])
      @postag = PostTag.find_by(post_id: params[:id])
      @tag = Tag.find_by(id: @postag.tag_id)
    end
  
    def update
      @post = Post.find_by(id: params[:id])
      @post.word = params[:word]
      @post.mean = params[:mean]
      @post.image = params[:image]
      @postag = PostTag.find_by(post_id: @post.id)
      @postag.tag_id = params[:tag_id]
      @synonym = Synonym.find_by(post_id: @post.id)
      @synonym.synonym = params[:synonym]
      if @post.save
         @postag.save
         @synonym.save
         flash[:notice] = "タグを編集しました。"
         redirect_to("/posts/index")
      else
        render("/posts/new")
      end
    end
  
    def show
      @post = Post.find_by(id: params[:id])
      @user = @post.user_id
      @postag = PostTag.find_by(post_id: @post.id)
      @synonyms = Synonym.where(post_id: @post.id)
      if @postag.nil?
        p ""
      else
        @tag = Tag.find_by(id: @postag.tag_id)
        @synonym = Synonym.find_by(post_id: @post.id)
      end
    end
  
    def destroy
      @post = Post.find_by(id: params[:id])
      if @post.destroy
      redirect_to("/posts/index")
      end
    end
  end
  