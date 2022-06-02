class PostTag < ApplicationRecord

  belongs_to :post
  belongs_to :tag, optional: true
  #validates :post_id, presence: true

  def self.search(search)
    if search
      where(["name LIKE ?", "%#{search}%"])
    else
      all
    end
  end
end