class WorkbooksController < ApplicationController
    protect_from_forgery except: :new_flashcard
    protect_from_forgery except: :new_flashcard_js

    def flashcard
    end

    def ready
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
        @count = 1
        @question = 0

        @postbooks = PostBook.where(workbook_id: params[:id]) #10問持ってきてる
        @posts = Post.where(id: @postbooks.map { |postbook| postbook.post_id }.split(","))
        @synonyms = Synonym.where(post_id: @posts.map { |post| post.id }.split(","))
        @post = @posts[@question].word
        @synonym = @synonyms[@question].synonym
                    @choices = Post.all.sample(2)
                if  @choices.include?(@randomword)
                    @choices.uniq + Post.all.sample(1)
                end
                @choice = @choices.pluck(:mean)
                @array = [@choice[0], @choice[1],@posts[@question].mean].shuffle

    end

    def new_flashcard_js
        new_flashcard
        @answer_memory = PostBook.find_by(post_id: @posts[@question].id)
        @answer_memory.update(answer: params[:answer])
        binding.pry
        @count = @postbooks.where(answer: "*").count + 1
        @question = @count - 1
        p @count
        p @question
        @post = @posts[@question].word
        @synonym = @synonyms[@question].synonym
    end
end
