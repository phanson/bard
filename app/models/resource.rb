class Resource < ActiveRecord::Base
  belongs_to :type, class_name: "ResourceType"
  validates :name, presence: true
end
