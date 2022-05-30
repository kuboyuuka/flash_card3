require 'rails_helper'
describe 'ユーザ登録機能' do
    context 'ユーザAが新規登録している時' do
        before do
            #新規登録画面に遷移
            visit signup_path
            #メールアドレス、パスワードを入力
            fill_in 'email', with: 'skdjdskajg'
            fill_in 'password', with: '123456789'
            fill_in 'password_confirmation', with: '123456789'
            #登録ボタンを押す
            click_button '登録する'
            redirect_to "http://localhost:3000/main"
        end
    end
end