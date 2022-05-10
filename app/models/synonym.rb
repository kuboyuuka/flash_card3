class Synonym < ActiveRecord::Base
    belongs_to :post

    scope :search, -> (keyword) {
        where('title like :q OR name like :q',q: "#{keyword}") if keyword.present?
       }

    def self.search(search)
        if search
            Synonym.where(["synonym LIKE ?", "#{search}"])
        else
            Synonym.all
        end
    end

end
