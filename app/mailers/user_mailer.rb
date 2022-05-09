class UserMailer < ApplicationMailer
    default from: 'kubo@asnica.co.jp'

    def run
        User.find_each do |user|
            UserMailer.with(user: user).send_when_signup.deliver_now
        end
    end

    def send_when_signup
        @user = params[:user]
        @url = 'http://localhost:3000/login'
        mail(
            to: @user.email,
            subject: '単語帳の新規登録完了のお知らせ'
        )
    end
end
