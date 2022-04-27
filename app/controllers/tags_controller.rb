class TagsController < PostsController

    def create
      @tag = Tag.new(name: params[:name])
      if @tag.save
        redirect_to("/tags/index")
      else
        render:tag_new
      end
    end

    def tag
    end

    def  show
      @tag = Tag.find_by(id: params[:id])
      @postags = PostTag.where(tag_id: @tag.id)
      @posts = Post.where(id: @postags.map{|postag| postag.post_id})
    end
  
    def index
      @tags = Tag.all
    end

    def edit
      @tag = Tag.find_by(id: params[:id])
    end

    def update
      @tag = Tag.find_by(id: params[:id])
      @tag.name = params[:name]
      if @tag.save
         flash[:notice] = "タグを編集しました。"
         redirect_to("/tags/index")
      else
        render("/tags/edit")
      end
    end

    def destroy
      @tag = Tag.find_by(id: params[:id])
      if@tag.destroy
      redirect_to("/tags/index")
      end
    end

end
