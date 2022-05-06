class RegisterMailer < ApplicationMailer
    def send_mail(register)
    @register = register
        mail(
            from: 'kubo@asnica.co.jp',
            to: 'coco_rara_0309@icloud.com',
            subject: '単語帳新規登録完了のお知らせ'
        )
end
