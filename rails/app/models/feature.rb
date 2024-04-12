class Feature < ApplicationRecord
	has_many :comments, class_name: 'Comment', foreign_key: 'feature_id'
end

