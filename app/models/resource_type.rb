class ResourceType < ActiveRecord::Base
  has_many :resources, foreign_key: "type_id"

  validates :name, length: { minimum: 3 }
end
