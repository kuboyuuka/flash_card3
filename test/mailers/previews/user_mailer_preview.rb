# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
    def user
        user = User.new(name: "久保優花", email: "coco_rara_0309@icloud.com")
        UserMailer.send_mail(user)
    end
end
