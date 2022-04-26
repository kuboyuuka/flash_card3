class SynonymsController < PostsController
    def new
        @synonym = Synonym.new
    end

    def create
        @synonym = Synonym.new(synonym: params[:synonym],post_id: @post.id)
        @synonym.save
    end

    def search
        @synonyms = Synonym.search(params[:keyword])
    end

end
