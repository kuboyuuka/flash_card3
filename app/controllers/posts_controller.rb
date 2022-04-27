class PostsController < ApplicationController

    def ranking
    end
  
    def new
      @post = Post.new
      @synonym = @post.synonyms.build
      @tags = Tag.all
      @tag = Tag.new
      @postags = PostTag.all
    end
  
    def create
      @post = Post.new(word: params[:word],mean: params[:mean])
      @post.user_id = @current_user.id
      @postag = PostTag.find_by(tag_id: params[:tag_id])
      if @post.save
         redirect_to my_post_user_path(id: current_user)
         @postag = PostTag.new(post_id: @post.id, tag_id: params[:tag_id])
         @postag.save
         @synonym = Synonym.new(synonym: params[:synonym],post_id: @post.id)
         @synonym.save
         redirect_to("/posts/index")
      else
        render:new
      end
    end

    def post_params
      params.require(:post_form).permit(:word, :mean, :user_id, :synonym)
      params.require(:post).permit(:word, tags_attributes: [:tag])
      params.require(:synonym).permit(:synonym, :description, synonym_attributes: [:synonym])
    end

    def search
      @posts = Synonym.includes(:posts).references(:posts)
      @synonyms = Synonym.search(:keyword)
    end
  
    def index
      @posts = Post.all.order(created_at: :desc)
      @posts = Post.all.search(params[:search])
      @postags = PostTag.all
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
        p @post.errors.full_messages
      end
    end
  
    def show
      @post = Post.find_by(id: params[:id])
      @user = @post.user_id
      @postag = PostTag.find_by(post_id: @post.id)
      @tag = Tag.find_by(id: @postag.tag_id)
      @synonym = Synonym.find_by(post_id: @post.id)
    end
  
    def destroy
      @post = Post.find_by(id: params[:id])
      if @post.destroy
      redirect_to("/posts/index")
      end
    end
  end
  