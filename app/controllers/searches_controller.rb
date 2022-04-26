class SearchesController < PostsController
  def search
    @tags = Tag.search(params[:keyword])
  end
end
