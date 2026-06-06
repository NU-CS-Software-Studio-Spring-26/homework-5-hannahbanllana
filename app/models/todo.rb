class Todo < ApplicationRecord
    scope :with_category, ->(category) { where(category: category) }
  end
