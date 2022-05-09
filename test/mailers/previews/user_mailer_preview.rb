# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

    def send_when_signup
        UserMailer.with(user: User.find_by(email: 'coco_rara_0309@icloud.com')).send_when_signup
    end

end
