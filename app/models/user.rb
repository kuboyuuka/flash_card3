class User < ApplicationRecord

    #include ActiveModel::Model
    #attr_accessor :name, :email

    has_secure_password
    has_many :posts, dependent: :destroy
    has_many :tags,through: :post_tags
    validates :name,{presence:true}
    validates :email, {presence:true,uniqueness:true}
    validates :password, {presence:true,length: {minimum: 6},allow_nil:true,confirmation:true}
    validates :password_confirmation, {confirmation: true,allow_nil: true}
end
