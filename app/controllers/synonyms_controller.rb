class SynonymsController < PostsController
    def new
        @synonym = Synonym.new
    end

    def create
        
        @synonym = Synonym.new(synonym: params[:synonym],post_id: @post.id)
        @synonym.save
        
    end

    def synonym_params
        params.require(:synonym).permit(:synonym, synonym_attributes: [:synonym, :attr2, :attr3])
      end

    def search
        @synonyms = Synonym.search(params[:keyword])
    end

end
