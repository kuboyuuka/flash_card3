class Post < ApplicationRecord
    validates :word, {presence: true}
    validates :mean, {presence: true}
    validates :post_id, {presence: true}
    validates :tag_id, {presence: true}
    belongs_to :user
    belongs_to :tag
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
