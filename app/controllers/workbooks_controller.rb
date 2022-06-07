class WorkbooksController < ApplicationController
    protect_from_forgery except: :new_flashcard
    protect_from_forgery except: :new_flashcard_js
    include AjaxHelper
    require 'securerandom'

    def flashcard
        @records = Record.where(user_id: @current_user.id)
        @scores = @records.pluck(:score)
        @workbooks = @records.pluck(:workbook_id)
        @array = @scores.zip(@workbooks)
    end

    def ready
        @workbook = Workbook.new
        @workbook.user_id = @current_user.id
            if  @workbook.save
                @record = Record.new(user_id: @current_user.id, workbook_id: @workbook.id)
                @record.save
                @posts = Post.all
                @randomwords = @posts.sample(10)
                @randomwords.each_with_index do |randomword, idx|
                    idx += 1
                    @randomword = randomword.word
                        PostBook.new(post_id: randomword.id,workbook_id: @workbook.id,question_id: idx).save
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
            p "----------------------------------"

    elsif   params[:commit] == "採点する"
            @answer_memory = PostBook.find_by(workbook_id: params[:id],question_id: params[:question_id])
            @answer_memory.update(answer: params[:answer])
            
            respond_to do |format|
                format.js {render ajax_redirect_to( "/workbooks/#{params[:id]}/confirmation")} 
            end
        else
            respond_to do |format|
                format.js {render ajax_redirect_to( "/workbooks/flashcard")} 
            end

        end

    end

    def judgement
        @postbooks = PostBook.where(workbook_id: params[:id]).sort_by(&:question_id)
        @update_car = User.find_by(id: @current_user.id)
        @postbooks.each do |postbook|
            if  postbook.answer == Post.find_by(id: postbook.post_id).mean
                @answer_memory = PostBook.find_by(id: postbook.id)
                @answer_memory.update(judgment: "正解")
            elsif postbook.answer == nil
                @answer_memory = PostBook.find_by(id: postbook.id)
                @answer_memory.update(judgment: "未回答")
            else
                @answer_memory = PostBook.find_by(id: postbook.id)
                @answer_memory.update(judgment: "不正解")
            end
        end
        @scoring = @postbooks.pluck(:judgment)
        @score = @scoring.count("正解")
        @score_memory = Record.find_by(workbook_id: params[:id])
        @score_memory.update(score: @score)
        @yourworkbooks = Record.where(user_id: @current_user.id).pluck(:score).compact
        @denominations = @yourworkbooks.count * 10
        @yourrecords = @yourworkbooks.sum
        @car = (@yourrecords.to_f / @denominations.to_f * 100).to_i
        @update_car.update(car: @car)
    end

    def judge_synonym
        if  @posts[@question].synonyms.exists?
            @synonyms = @posts[@question].synonyms
            @synonym = @synonyms.pluck(:synonym)
        else
            ""
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

    def onemore
        @workbook = Workbook.new
        @workbook.user_id = @current_user.id
            if  @workbook.save
                @record = Record.new(user_id: @current_user.id, workbook_id: @workbook.id)
                @record.save
                @prepostbooks = PostBook.where(workbook_id: params[:id])
                @prepostbooks.each_with_index do |randomword, idx|
                    idx += 1
                    PostBook.new(post_id:randomword.post_id,workbook_id: @workbook.id,question_id: idx).save
                end
            end
        redirect_to action: :new_flashcard, id: params[:id]
    end

    def ranking
        @users = User.all
        @yourworkbooks = Record.where(user_id: @current_user.id).pluck(:score).compact
        @denominations = @yourworkbooks.count * 10
        @yourrecords = @yourworkbooks.sum
        @car = User.find_by(id: @current_user.id).car
        @rankings = User.order(car: :desc) - User.where(car: nil)
        @rankings = Kaminari.paginate_array(@rankings).page(params[:page]).per(10)
    end

    def myranking
        ranking
        @tie = 0
        @rank = 1
        @rankings.each.with_index(1) do |ranking , i|
            if i == 1
                @tie = ranking.car
                if ranking.id == @current_user.id
                    @myrank = @rank
                end
            end 
            if ranking.car != @tie 
                @rank = i
                if ranking.id == @current_user.id
                    @myrank = @rank
                end
                @tie = ranking.car
            else
                if ranking.id == @current_user.id
                    @myrank = @rank
                end
                @tie = ranking.car
            end
        end
    end
end