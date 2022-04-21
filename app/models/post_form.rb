class PostForm < ApplicationRecord
   include ActiveModel::Model 
   attr_accessor :word, :mean, :user_id, :tag, :synonym
end
