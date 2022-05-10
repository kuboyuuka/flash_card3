class Posts::SearchesController < PostsController
  def search
    @posts = Post.search(params[:keyword])
  end
end
