class Post < ApplicationRecord
    validates :word, {presence: true}
    validates :mean, {presence: true}
    belongs_to :tag, optional: true
    def self.search(search)
        if search
          where(["name LIKE ?", "%#{search}%"])
        else
          all
        end
    end

    def user
      return User.find_by(id: self.user.id)
    end
end
