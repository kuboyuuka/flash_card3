class Tag < ApplicationRecord
    include ActiveModel::Model
    has_many :tags
    accepts_nested_attributes_for :tags, allow_destroy: true
end
