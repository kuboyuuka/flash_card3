class Tag < ApplicationRecord

    has_many :posts,dependent: :destroy, foreign_key: 'post_id'
    has_many :users,through: :posts
    validates :name, uniqueness: true, presence: true
end
