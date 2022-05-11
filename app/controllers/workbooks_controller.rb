class WorkbooksController < ApplicationController

    def flashcard
    end

    def ready
        @count = 0
        @correct_answer = 0
        @workbook = Workbook.new
        @workbook.user_id = @current_user.id
            if  @workbook.save
                @randomwords = Post.all.sample(10)
                @randomwords.each do |randomword|
                    @randomword = randomword.word
                    @post_book = PostBook.new(post_id: randomword.id,workbook_id: @workbook.id)
                    @post_book.save
                end
            end
    end

    def new_flashcard
        @postbooks = PostBook.where(workbook_id: params[:id])
        @postbooks.each do |postbook|
            @post = Post.find_by(id: postbook.post_id)
                @synonyms = @post.synonyms.each do |synonym|
                    @synonym = synonym.synonym
                    @choices = Post.all.sample(2)
                #if  @choices.include?(@randomword)
                    #@choices.uniq + Post.all.sample(1)
                #end
                @choice = @choices.pluck(:mean)
                    @array = [@choice[0], @choice[1],@post.mean].shuffle
                    @workbook = Workbook.update(answer: params[:answer])
                
            end
        end
    end

end
