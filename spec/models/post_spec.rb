require 'rails_helper'
FactoryBot.define do
    RSpec.describe Post, type: :model do
      it "does not allow duplicate post" do
        user = User.create(
          name: "久保優花",
          email: "cocococo",
          password: "123456789",
          password_confirmation: "123456789"
        )

        user.posts.create(
          word: "Hello",
          mean: "こんにちは",
        )

        new_post = user.posts.build(
          word: "Hello",
          mean: "こんにちは",
        )

        new_post.valid?
        expect(new_post.errors[:word]).to include("has already been taken")
      end
      describe "#search" do
        context  "一致するデータが存在する場合" do
          it "検索文字列に完全一致する配列を返すこと" do
            expect(Post.search("test-name1"))
          end
          it "検索文字列に部分一致する配列を返すこと" do
            expect(Post.search("t"))
          end
          it "update_at降順で配列を返すこと" do
            expect(Post.order("update_at DESC").map)
          end
          context "一致するデータが存在しない場合"
            it "検索文字列が一致しない場合、空の配列を返すこと" do
            expect(Post.search("あああ")).to be_empty
          end

          it "検索文字列が空白の場合、全ての配列を返すこと" do
            expect(Post.search(""))
          end
        end
      end
    end    
end