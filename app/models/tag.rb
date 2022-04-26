class Tag < ActiveRecord::Base
    #include ActiveModel::Model
    #attr_accessor :name, :word, :mean, :tag_id

    has_many :post_tags,dependent: :destroy, foreign_key: 'tag_id'
    has_many :posts,through: :post_tags
    has_many :post_tags

    class << self
        def search(search)
            return Tag.all unless search
            Tag.where('name LIKE(?)', "%#{search}%")
        end
    end

end
