class Post < ApplicationRecord
  #include ActiveModel::Model
  #attr_accessor :name, :word, :mean, :tag_id

  validates :word, {presence: true}
  validates :mean, {presence: true}
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :synonyms, dependent: :destroy
    def self.search(search)
      if search
        where(["name LIKE ?", "%#{search}%"])
      else
        all
      end
    end

    def user
    end
end
