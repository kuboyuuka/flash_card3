require 'csv'

CSV.generate do |csv|
    column_names = %w(word mean)
    csv << column_names
    @posts.each do |post|
      column_values = [
        post.word, 
        post.mean
      ]
      csv << column_values
    end
  end