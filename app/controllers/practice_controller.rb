class PracticeController < ApplicationController
  protect_from_forgery except: :index
  def index
    p request.xhr?
    @count = 0
    @count += params[:count].to_i
    respond_to do |format|
      format.html
      format.js
    end
  end
end
