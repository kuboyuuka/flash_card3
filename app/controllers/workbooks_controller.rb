class WorkbooksController < ApplicationController
    protect_from_forgery except: :new_flashcard
    protect_from_forgery except: :new_flashcard_js
    include AjaxHelper
    require 'securerandom'

    def flashcard
    end

    def ready
        @workbook = Workbook.new
        @workbook.user_id = @current_user.id
            if  @workbook.save
                @record = Record.new(user_id: @current_user.id, workbook_id: @workbook.id)
                @record.save
                @randomwords = Post.offset(rand(Post.count)).first(10)
                @randomwords.each_with_index do |randomword, idx|
                    @randomword = randomword.word
                        @postbook = PostBook.new(post_id: randomword.id,workbook_id: @workbook.id,question_id: idx + 1).save
                end
            end
    end

    def new_flashcard
        @count = 1
        @question = 0
        @postbooks = PostBook.where(workbook_id: params[:id]) #10問持ってきてる
        @posts = Post.where(id: @postbooks.map { |postbook| postbook.post_id }.split(","))
        @post = @posts[@question]
        @postbook = PostBook.find_by(post_id: @post.id,workbook_id: params[:id])
        @postbook.update(question_id: 1)
        @synonyms = @posts[@question].synonyms
        @synonym = @synonyms.pluck(:synonym)
        @except = Post.select{ |post| post[:mean] != @post.mean }
        @choices = @except.sample(2)
        @choice = @choices.pluck(:mean)
        @array = [@choice[0], @choice[1],@post.mean].shuffle
        @button = "次の問題へ"
    end

    def new_flashcard_js
        @count = 
        @post = PostBook.find_by(question_id: @questionparams[:id],)
        @postbooks = PostBook.where(workbook_id: params[:id]) #10問持ってきてる
        @posts = Post.where(id: @postbooks.map { |postbook| postbook.post_id }.split(","))
        @button = "次の問題へ"
        if  @count == 10
            @button = "採点する"
        end
        if  params[:commit] == "次の問題へ"
            @answer_memory = @postbooks.find_by(post_id: @posts[@question].id)
            @answer_memory.update(answer: params[:answer])
            if  @answer_memory.answer == Post.find_by(id: @answer_memory.post_id).mean
                @answer_memory.update(judgment: "true")
            elsif
                @answer_memory.update(judgment: "false")
            elsif
                @answer_memory.update(judgment: "未回答")
            end
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
            Record.update(score: @scoring)
            respond_to do |format|
                format.js {render ajax_redirect_to( "/workbooks/#{$id}/confirmation")} 
            end
        end
    end

    def confirmation
        @postbooks = PostBook.where(workbook_id: params[:id])
    end

    def judgement
        @postbooks = PostBook.where(workbook_id: $id)  #paramsのidがここで変わってnilになる
        @score = Record.find_by(workbook_id: $id).score
    end

    def continue

    end
end