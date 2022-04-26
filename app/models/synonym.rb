class Synonym < ActiveRecord::Base
    belongs_to :post

    class << self
        def search(search)
            if search
                where(["synonym LIKE ?", "%#{search}%"])
            else
                all
            end
        end
    end

end
