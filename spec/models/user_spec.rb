require 'rails_helper' 

  RSpec.describe User, type: :model do
      # 姓、名、メール、パスワードがあれば有効な状態であること
      it "is valid with a first name, last name, email, and password" do
        user = User.new(
          name:       "Aaron Sumner",
          email:      "tester@example.com",
          password:   "dottle-nouveau-pavilion-tights-furze",
          )
        expect(user).to be_valid
      end
      # 名前がなければ無効な状態であること
      it "is invalid without a name" do
        user = User.new(name: nil)
        user.valid?
        expect(user.errors[:name]).to include("can't be blank") 
      end
      # メールアドレスがなければ無効な状態であること
      it "is invalid without an email address" do
        user = User.new(email: nil)
        user.valid?
        expect(user.errors[:email]).to include("can't be blank")
      end
      #重複したメールアドレスなら無効な状態であること
      it "is invalid with a duplicate email address" do
        User.create(
          name: "久保優花",
          email: "coco_rara_0309@icloud.com",
          password: "ppppppppppppp",
        )
        user = User.new(
          name: "kuboyuka",
          email: "coco_rara_0309@icloud.com",
          password: "ppppppppppppp",
        )
        user.valid?
        expect(user.errors[:email]).to include("has already been taken")
      end
      context 'not be able to create' do
        it "is invalid without a nickname" do
          user = FactoryBot.build(:user,name: "")
          user.valid?
          expect(user.errors[:name]).to include("can't be blank")
        end
      end
end