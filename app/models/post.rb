class Post < ActiveRecord::Base

  validates :word, {presence: true,uniqueness: true}
  validates :mean, {presence: true,uniqueness: true}
  validates_associated :synonyms
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :synonyms, dependent: :destroy
  has_many :workbooks, dependent: :destroy
  accepts_nested_attributes_for :synonyms, allow_destroy: true
  mount_uploader :image, ImageUploader

  scope :search, -> (keyword) {
    where('title like :q OR name like :q',q: "#{keyword}") if keyword.present?
   }

  def self.search(search)
    if search
      Post.where(["word LIKE ? OR mean LIKE ?", "#{search}", "#{search}"])
    else
      Post.all
    end
  end

    def user
    end
end
