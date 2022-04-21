class PostTag < ApplicationRecord
  #include ActiveModel::Model
  #attr_accessor :name, :word, :mean, :tag_id

  belongs_to :post
  belongs_to :tag
  validates :post_id, presence: true
  validates :tag_id, presence: true
end
