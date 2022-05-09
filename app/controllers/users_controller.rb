class UsersController < ApplicationController
  before_action :authenticated_user, {only: [:index, :show, :edit, :update]}
  before_action :ensure_correct_user, {only: [:edit, :update]}
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(name: params[:name],email: params[:email],password: params[:password],password_confirmation: params[:password_confirmation])
    if @user.save
      flash[:notice] = "#{@user.name}さん、単語帳へようこそ！"
      UserMailer.with(user: @user).send_when_signup.deliver_later
      redirect_to("/main")
    else
      p @user.errors.full_messages
      render("users/new")
    end
  end

  def login_form
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      redirect_to("/main")
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]
      render("users/login_form")
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/login")
  end
end
