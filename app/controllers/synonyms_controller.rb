class SynonymsController < PostsController
    def create
        
    end

    def synonym_params
        params.require(:synonym).permit(:synonym, synonym_attributes: [:synonym, :attr2, :attr3])
      end

    def search
        @synonyms = Synonym.search(params[:keyword])
    end

end
