class Post < ApplicationRecord
    validates :word, {presence: true}
    validates :mean, {presence: true}
    has_many :post_tags, dependent: :destroy
    has_many :tags, through: :post_tags
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
