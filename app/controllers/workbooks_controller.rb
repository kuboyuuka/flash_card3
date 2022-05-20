class WorkbooksController < ApplicationController
    protect_from_forgery except: :new_flashcard
    protect_from_forgery except: :new_flashcard_js
    include AjaxHelper
    require 'securerandom'

    def flashcard
        @records = Record.where(user_id: @current_user.id)
        @scores = @records.pluck(:score)
        @records.each do |record|
            @workbook_id = record.workbook_id
        end
    end

    def ready
        @workbook = Workbook.new
        @workbook.user_id = @current_user.id
            if  @workbook.save
                @record = Record.new(user_id: @current_user.id, workbook_id: @workbook.id)
                @record.save
                @except = Post.select{ |post| post.id != 166 || post.id != 165}
                @randomwords = @except.sample(10)
                @randomwords.each_with_index do |randomword, idx|
                    idx += 1
                    @randomword = randomword.word
                        @postbook = PostBook.new(post_id: randomword.id,workbook_id: @workbook.id,question_id: idx).save
                end
            end
    end

    def new_flashcard
        @question = PostBook.find_by(workbook_id: params[:id],question_id: 1)
        @count = @question.question_id
        @word = Post.find_by(id: @question.post_id)
        if  @word.synonyms.exists?
            @synonym = @word.synonyms.pluck(:synonym)
        else
            ""
        end
        @except = Post.select{ |post| post[:mean] != @word.mean }
        @choices = @except.sample(2)
        @choice = @choices.pluck(:mean)
        @array = [@choice[0], @choice[1],@word.mean].shuffle
        @button = "次の問題へ"
    end

    def new_flashcard_js
        @answer_memory = PostBook.find_by(workbook_id: params[:id],question_id:params[:question_id])
        @answer_memory.update(answer: params[:answer])

        judge_answer

        @count = params[:question_id].to_i
        if @count < 10
            if params[:commit] ==  "次の問題へ"
                @count += 1
            elsif   params[:commit] == "前の問題へ"
                @count -= 1
            end
        end

        p @count

        @question = PostBook.find_by(workbook_id: params[:id],question_id: @count)
        @word = Post.find_by(id: @question.post_id)
        if  @word.synonyms.exists?
            @synonym = @word.synonyms.pluck(:synonym)
        else
            ""
        end
        @except = Post.select{ |post| post[:mean] != @word.mean }
        @choices = @except.sample(2)
        @choice = @choices.pluck(:mean)
        @array = [@choice[0], @choice[1],@word.mean].shuffle

        if  @count == 10
            p "----------------"
            @button = "採点する"
        else
            @button = "次の問題へ"
        end

        if  params[:commit] == "次の問題へ"
            @answer_memory = PostBook.find_by(workbook_id: params[:id],question_id: params[:question_id])
            @answer_memory.update(answer: params[:answer])

            judge_answer

            @word = Post.find_by(id: @question.post_id)
        if  @word.synonyms.exists?
            @synonym = @word.synonyms.pluck(:synonym)
        else
            ""
        end
            @except = Post.select{ |post| post[:mean] != @word.mean }
            @choices = @except.sample(2)
            @choice = @choices.pluck(:mean)
            @array = [@choice[0], @choice[1],@word.mean].shuffle
            p params
    elsif   params[:commit] == "前の問題へ"
            p "----------------------------------"
            @id_update = PostBook.find_by(question_id: params[:id])
            p @id_update.update(question_id: @question-1)
            p @post = @posts[@question]
            judge_synonym
            choices_answer
            p "----------------------------------"

    elsif   params[:commit] == "採点する"
            @answer_memory = PostBook.find_by(workbook_id: params[:id],question_id: params[:question_id])
            @answer_memory.update(answer: params[:answer])
            
            judge_answer
            @postbooks = PostBook.where(workbook_id: params[:id])
            @scoring = @postbooks.where(judgment:"正解").count
            @score = Record.find_by(workbook_id: params[:id])
            @score.update(score: @scoring)
            respond_to do |format|
                format.js {render ajax_redirect_to( "/workbooks/#{params[:id]}/confirmation")} 
            end
    else
        respond_to do |format|
            format.js {render ajax_redirect_to( "/workbooks/flashcard")} 
        end
        end

    end

    def new_flashcard_back
        workbook_temp
        @question =  Workbook.find_by(id: params[:id]).question_id
        i = 0
        if  params[:commit] ==  "前の問題へ"
            i  += 1
        else
            i = 0
        end
        if  i == 1
            @question -= 2
        elsif i > 1
            @question -= 1
        end
        @id_update = Workbook.find_by(id: params[:id])
        @id_update.update(question_id: @question)
    end

    def judge_synonym
        if  @posts[@question].synonyms.exists?
            @synonyms = @posts[@question].synonyms
            @synonym = @synonyms.pluck(:synonym)
        else
            ""
        end
    end
    
    def judge_answer
        if  @answer_memory.answer == Post.find_by(id: @answer_memory.post_id).mean
            @answer_memory.update(judgment: "正解")
        elsif @answer_memory.answer == nil
            @answer_memory.update(judgment: "未回答")
        else
            @answer_memory.update(judgment: "不正解")
        end
    end

    def choices_answer
        @except = Post.select{ |post| post[:mean] != @posts[@question].mean }
            @choices = @except.sample(2)
            @choice = @choices.pluck(:mean)
            @array = [@choice[0], @choice[1],@posts[@question].mean].shuffle
    end

    def workbook_temp
        @postbooks = PostBook.where(workbook_id: params[:id])
    end

    def confirmation
        @postbooks = PostBook.where(workbook_id: params[:id]).sort_by(&:question_id)
    end

    def judgement
        @postbooks = PostBook.where(workbook_id: params[:id]).sort_by(&:question_id)
        @score = Record.find_by(workbook_id: params[:id]).score
    end

    def continue
        @questions = PostBook.where(workbook_id: params[:id],answer: nil)
        @question = @questions.min
        @count = @question.question_id
        workbook_temp #10問持ってきてる
        @word = Post.find_by(id: @question.post_id)
        if  @word.synonyms.exists?
            @synonym = @word.synonyms.pluck(:synonym)
        else
            ""
        end
        @except = Post.select{ |post| post[:mean] != @word.mean }
        @choices = @except.sample(2)
        @choice = @choices.pluck(:mean)
        @array = [@choice[0], @choice[1],@word.mean].shuffle
        @button = "次の問題へ"
    end
end