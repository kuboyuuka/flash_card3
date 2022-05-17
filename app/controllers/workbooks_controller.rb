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
        $count = 1
        $question = 0

        @postbooks = PostBook.where(workbook_id: params[:id]) #10問持ってきてる
        @posts = Post.where(id: @postbooks.map { |postbook| postbook.post_id }.split(","))
        @post = @posts[$question]
        @synonyms = @posts[$question].synonyms
        @synonym = @synonyms.pluck(:synonym)
        @except = Post.select{ |post| post[:mean] != @posts[$question].mean }
        @choices = @except.sample(2)
        @choice = @choices.pluck(:mean)
        @array = [@choice[0], @choice[1],@posts[$question].mean].shuffle
        @button = "次の問題へ"
    end

    def new_flashcard_js
        @postbooks = PostBook.where(workbook_id: params[:id]) #10問持ってきてる
        @posts = Post.where(id: @postbooks.map { |postbook| postbook.post_id }.split(","))
        @button = "次の問題へ"
        if  $count == 9
            @button = "採点する"
        end
        if  params[:commit] == "次の問題へ"
            @answer_memory = @postbooks.find_by(post_id: @posts[$question].id)
            @answer_memory.update(answer: params[:answer])
            if  @answer_memory.answer == Post.find_by(id: @answer_memory.post_id).mean
                @answer_memory.update(judgment: "true")
            elsif
                @answer_memory.update(judgment: "false")
            elsif
                @answer_memory.update(judgment: "未回答")
            end
            $count += 1
            $question += 1
            @post = @posts[$question]
            @synonyms = @posts[$question].synonyms
            @synonym = @synonyms.pluck(:synonym)
            @except = Post.select{ |post| post[:mean] != @posts[$question].mean }
            @choices = @except.sample(2)
            @choice = @choices.pluck(:mean)
            @array = [@choice[0], @choice[1],@posts[$question].mean].shuffle
    elsif   params[:commit] == "前の問題へ"
            @answer_memory = @postbooks.find_by(post_id: @posts[$question].id)
            @answer_memory.update(answer: params[:answer])
            if  @answer_memory.answer == Post.find_by(id: @answer_memory.post_id).mean
                @answer_memory.update(judgment: "true")
            elsif
                @answer_memory.update(judgment: "false")
            elsif
                @answer_memory.update(judgment: "未回答")
            end
            $count -= 1
            $question -= 1
            @post = @posts[$question]
            @synonyms = @posts[$question].synonyms
            @synonym = @synonyms.pluck(:synonym)
            @except = Post.select{ |post| post[:mean] != @posts[$question].mean }
            @choices = @except.sample(2)
            @choice = @choices.pluck(:mean)
            @array = [@choice[0], @choice[1],@posts[$question].mean].shuffle
    elsif   params[:commit] == "採点する"
            @answer_memory = @postbooks.find_by(post_id: @posts[$question].id)
            @answer_memory.update(answer: params[:answer])
            if  @answer_memory.answer == Post.find_by(id: @answer_memory.post_id).mean
                @answer_memory.update(judgment: "true")
            elsif
                @answer_memory.update(judgment: "false")
            elsif
                @answer_memory.update(judgment: "未回答")
            end
            @scoring = @postbooks.where(judgment:"true").count
            Workbook.update(score: @scoring)
            redirect_to  action: :confirmation

        end
    end

    def confirmation
        @postbooks = PostBook.where(workbook_id: params[:id])
    end

    def judgement
        @postbooks = PostBook.where(workbook_id: params[:id])
    end

    def continue

    end
end