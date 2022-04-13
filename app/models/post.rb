class Post < ApplicationRecord
    belongs_to :tag
    def self.search(search)
        if search
          where(["name LIKE ?", "%#{search}%"])
        else
          all
        end
      end
end
