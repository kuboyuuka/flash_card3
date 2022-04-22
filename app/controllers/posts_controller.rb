class PostsController < ApplicationController

    def ranking
    end
  
    def new
      @post = Post.new
      @synonym = Synonym.new
      @tag = Tag.new
      @tags = Tag.all
      @posttags = PostTag.all
    end
  
    def create
      @post = Post.new(word: params[:word],mean: params[:mean])
      @post.user_id = @current_user.id
      @synonym = Synonym.new(synonym: params[:synonym])
      if @post.save
         @tags.each do |tag|
            @synonym.save
            @postag = PostTag.new(post_id: @post.id,tag_id: tag.id)
            @postag.save
            @synonym_tag = Synonym.find_by(post_id: @post.id)
            @synonym_tag.update(post_id: @post.id)
         end
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
      @posts.each do |post|
      @postags = PostTag.all
      #@postag = @postags.find_by(id: post.id)
      #@tag = Tag.find_by(id: @postag.tag_id)
      end
    end
  
    def edit
      @tags = Tag.all
      @post = Post.find_by(id: params[:id])
    end
  
    def update
      @postag = PostTag.find_by(id: @post.id)
      @tag = Tag.find_by(id: @postag.tag_id)
      @tag.name = params[:name]
      @post = Post.find_by(id: params[:id])
      @post.word = params[:word]
      @post.mean = params[:mean]
      @synonym = Synonym.find_by(id: @post.id)
      @synonym.synonym = params[:synonym]
      if @tag.save
        @post.save
        @synonym.save
         flash[:notice] = "タグを編集しました。"
         redirect_to("/posts/index")
      end
    end
  
    def show
      @post = Post.find_by(id: params[:id])
      @user = @post.user_id
      @postag = PostTag.find_by(id: @post.id)
      @tag = Tag.find_by(id: params[:id])
      @synonym = Synonym.find_by(id:@post.id)
    end
  
    def destroy
      @post = Post.find_by(id: params[:id])
      @post.destroy
      redirect_to("/posts/index")
    end
  end
  