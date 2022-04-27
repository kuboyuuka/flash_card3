class Post < ActiveRecord::Base
  #include ActiveModel::Model
  #attr_accessor :name, :word, :mean, :tag_id

  validates :word, {presence: true}
  validates :mean, {presence: true}
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :post_tags, dependent: :destroy
  has_many :synonyms, dependent: :destroy
  accepts_nested_attributes_for :synonyms, allow_destroy: true

  scope :search, -> (keyword) {
    where('title like :q OR name like :q',q: "%#{keyword}%") if keyword.present?
   }

  def self.search(search)
    if search
      where(["word LIKE ? OR mean LIKE ?", "%#{search}%", "%#{search}%"])
    else
      all
    end
  end

    def user
    end
end
