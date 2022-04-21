class Tag < ApplicationRecord
    #include ActiveModel::Model
    #attr_accessor :name, :word, :mean, :tag_id

    has_many :post_tags,dependent: :destroy, foreign_key: 'tag_id'
    has_many :posts,through: :post_tags
end
