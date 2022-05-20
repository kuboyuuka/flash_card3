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
                @randomwords.each do |randomword|
                    @randomword = randomword.word
                        @postbook = PostBook.new(post_id: randomword.id,workbook_id: @workbook.id).save
                end
            end
    end

    def new_flashcard
        @count = 1
        @question = 0
        $id = params[:id]
        @postbooks = PostBook.where(workbook_id: params[:id]) #10問持ってきてる
        @posts = Post.where(id: @postbooks.map { |postbook| postbook.post_id }.split(","))
        @post = @posts[@question]
        @id_update = Workbook.find_by(id: params[:id])
        @id_update.update(question_id: 1)
        @sortid = PostBook.find_by(workbook_id: params[:id],post_id:@post.id)
        @sortid.update(question_id: @count)
        if  @posts[@question].synonyms.exists?
            @synonyms = @posts[@question].synonyms
            @synonym = @synonyms.pluck(:synonym)
        end
        @except = Post.select{ |post| post[:mean] != @post.mean }
        @choices = @except.sample(2)
        @choice = @choices.pluck(:mean)
        @array = [@choice[0], @choice[1],@post.mean].shuffle
        @button = "次の問題へ"
    end

    def new_flashcard_js
            @question =  Workbook.find_by(id: params[:id]).question_id 
            @count = @question + 1
            @postbooks = PostBook.where(workbook_id: params[:id]) #10問持ってきてる
            @posts = Post.where(id: @postbooks.map { |postbook| postbook.post_id }.split(","))
            @post = @posts[@question]
            if  @posts[@question].synonyms.exists?
                @synonyms = @posts[@question].synonyms
                @synonym = @synonyms.pluck(:synonym)
            end
            @answer_memory = @postbooks.find_by(post_id: @posts[@question-1].id) 
            @answer_memory.update(answer: params[:answer])
            if  @answer_memory.answer == Post.find_by(id: @answer_memory.post_id).mean
                @answer_memory.update(judgment: "正解")
            elsif @answer_memory.answer == nil
                @answer_memory.update(judgment: "未回答")
            else
                @answer_memory.update(judgment: "不正解")
            end
            @button = "次の問題へ"
            if  @question == 9
                @button = "採点する"
            end
        if  params[:commit] == "次の問題へ"
            @id_update = Workbook.find_by(id: params[:id])
            @id_update.update(question_id: @question+1)
            @answer_memory = @postbooks.find_by(post_id: @posts[@question-1].id) 
            @answer_memory.update(answer: params[:answer])
            if  @answer_memory.answer == Post.find_by(id: @answer_memory.post_id).mean
                @answer_memory.update(judgment: "正解")
            elsif @answer_memory.answer == nil
                @answer_memory.update(judgment: "未回答")
            else
                @answer_memory.update(judgment: "不正解")
            end
            @post = @posts[@question]
            @sortid = PostBook.find_by(workbook_id: params[:id],post_id:@post.id)
            @sortid.update(question_id: @question)
            if  @posts[@question].synonyms.exists?
                @synonyms = @posts[@question].synonyms
                @synonym = @synonyms.pluck(:synonym)
            end
            @except = Post.select{ |post| post[:mean] != @posts[@question].mean }
            @choices = @except.sample(2)
            @choice = @choices.pluck(:mean)
            @array = [@choice[0], @choice[1],@posts[@question].mean].shuffle
        elsif params[:commit] == "前の問題へ"
            
            @id_update = Workbook.find_by(id: params[:id])
            @id_update.update(question_id: @question-1)
            @post = @posts[@question]
            if  @posts[@question].synonyms.exists?
                @synonyms = @posts[@question].synonyms
                @synonym = @synonyms.pluck(:synonym)
            end
            @except = Post.select{ |post| post[:mean] != @posts[@question].mean }
          p   @choices = @except.sample(2)
           p  @choice = @choices.pluck(:mean)
           p  @array = [@choice[0], @choice[1],@posts[@question].mean].shuffle
    elsif   params[:commit] == "採点する"
            @answer_memory = @postbooks.find_by(post_id: @posts[@question-1].id)
            @answer_memory.update(answer: params[:answer])
            judge
            @scoring = @postbooks.where(judgment:"正解").count
            @score = Record.find_by(workbook_id: params[:id])
            @score.update(score: @scoring)
            respond_to do |format|
                format.js {render ajax_redirect_to( "/workbooks/#{params[:id]}/confirmation")} 
            end
        end
    end

    def new_flashcard_back
        
    end

    def confirmation
        @postbooks = PostBook.where(workbook_id: params[:id]).sort_by(&:question_id)
    end

    def judgement
        @postbooks = PostBook.where(workbook_id: params[:id]).sort_by(&:question_id)
        @score = Record.find_by(workbook_id: params[:id]).score
    end

    def continue
        @count = params[:value].to_i
        @question = @count - 1
        @postbooks = PostBook.where(workbook_id: $id) #10問持ってきてる
        @posts = Post.where(id: @postbooks.map { |postbook| postbook.post_id }.split(","))
        @post = @posts[@question]
        @id_update = Workbook.find_by(id: $id)
        @id_update.update(question_id: @count) 
        @synonyms = @posts[@question].synonyms
        @synonym = @synonyms.pluck(:synonym)
        @except = Post.select{ |post| post[:mean] != @post.mean }
        @choices = @except.sample(2)
        @choice = @choices.pluck(:mean)
        @array = [@choice[0], @choice[1],@post.mean].shuffle
        @button = "次の問題へ"
    end
end