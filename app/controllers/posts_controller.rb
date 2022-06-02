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
      if p @post.save
         @postag = PostTag.create(post_id: @post.id)
         p @postag.errors.full_messages
         p @post.errors
         @postag.save
         if params[:post][:tag_id] != nil
          @tagsave = PostTag.find_by(post_id: @post.id)
          @tagsave.update(tag_id: params[:post][:tag_id])
         end
         redirect_to("/posts/index")
      else
        p 123
        p @post.errors.full_messages
        p @post.errors
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
        synonyms_attributes: [:id, :synonym]
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
      @synonym = @post.synonyms.build
      if Synonym.find_by(post_id: params[:id]) != nil
         @synonym = Synonym.find_by(post_id: params[:id])
      end
      if PostTag.find_by(post_id: params[:id]) != nil
         @postag = PostTag.find_by(post_id: params[:id])
         @tag = Tag.find_by(id: @postag.tag_id)
      end
    end
  
    def update
      @post = Post.find_by(id: params[:id])
      @post.update(post_params)
      if   PostTag.find_by(post_id: params[:id]) != nil
           @postag = PostTag.find_by(post_id: params[:id])
           @postag.update(tag_id: params[:post][:tag_id])
      else 
           @postag = PostTag.new(tag_id: params[:tag_id],post_id: @post.id)
           @postag.save
      end
      if  @synonym = Synonym.find_by(post_id: @post.id)
          @synonym.update(synonym: params[:post][:synonyms_attributes]["0"][:synonym])
          flash[:notice] = "更新しました"
          redirect_to("/posts/index")
      else
          render("/posts/edit")
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
  