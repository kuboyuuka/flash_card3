class Tag < ActiveRecord::Base

    has_many :post_tags,dependent: :destroy, foreign_key: 'tag_id'
    has_many :posts,through: :post_tags
    has_many :post_tags

    scope :search, -> (keyword) {
        where('title like :q OR name like :q',q: "#{keyword}") if keyword.present?
       }
    
      def self.search(search)
        if search
          Tag.where(["name LIKE ?", "#{search}"])
        else
          Tag.all
        end
      end

end
