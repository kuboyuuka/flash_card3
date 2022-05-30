require 'rails_helper'
describe '単語削除機能' do
    before do
        #ユーザA作成する
        @user_a = FactoryBot.create(:user)
    end
    context 'ユーザAがログインしている時' do
        before do
            #ユーザAでログイン
            #ログイン画面に遷移
            visit login_path
            #メールアドレス、パスワードを入力
            fill_in 'email', with: @user_a.email
            fill_in 'password', with: '123456789'
            #ログインボタンを押す
            click_button 'ログイン'
            redirect_to "http://localhost:3000/main"
        end

        it '単語一覧を表示' do
            #単語マスタを押す
            click_link '単語マスタ'
            #単語登録を押す
            click_link '単語登録'
            #単語登録する
            fill_in 'post[word]', with: 'asef'
            fill_in 'post[mean]', with: 'sfaf'
            click_button '登録'
            #削除したい単語を選択
            click_link 'asef'
            #削除を押す
            click_link '削除'
        end
    end
end