# Preview all emails at http://localhost:3000/rails/mailers/register_mailer
class RegisterMailerPreview < ActionMailer::Preview
    def register
        register = Register.new(name: "久保優花", message: "会員登録メッセージ")

        RegisterMailer.send_mail(register)
    end
end
