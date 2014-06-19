class Passage < ActiveRecord::Base
  validates :body, length: { minimum: 20 }

  belongs_to :resource
  belongs_to :author, class_name: "Person"
  has_and_belongs_to_many :tags
end
