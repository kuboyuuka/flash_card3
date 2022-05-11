class Workbook < ActiveRecord::Base
    has_many :post_books, dependent: :destroy
    has_many :records, dependent: :destroy
    belongs_to :user
end
