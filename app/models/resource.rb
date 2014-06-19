class Resource < ActiveRecord::Base
  validates :name, presence: true
  belongs_to :type, class_name: "ResourceType"
  has_many :passages
end
