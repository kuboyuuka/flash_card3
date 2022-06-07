class PostBook < ApplicationRecord
    belongs_to :post
    belongs_to :workbook
end
