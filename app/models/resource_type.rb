class ResourceType < ActiveRecord::Base
  has_many :resources

  validates :name, length: { minimum: 3 }
end
