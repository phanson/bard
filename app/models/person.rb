class Person < ActiveRecord::Base
  validates :name, presence: true

  has_many :passages, foreign_key: "author_id"
end
