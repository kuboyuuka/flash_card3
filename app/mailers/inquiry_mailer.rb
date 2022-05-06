class InquiryMailer < ApplicationMailer
    @inquiry = inquiry
    mail(
        from: 'kubo@asnica.co.jp',
        to: 'coco_rara_0309@icloud.com',
        subject: '単語帳の新規登録完了のお知らせ'
    )
end
