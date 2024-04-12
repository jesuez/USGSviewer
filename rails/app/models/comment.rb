class Comment < ApplicationRecord
	belongs_to :feature, class_name: 'Feature'
end
