class Tag < ActiveRecord::Base
  validates :name, length: { minimum: 2 }, format: { with: /\A[-\w\d ]+\z/ }, uniqueness: true
  before_save :downcase_name, :spaces_to_dashes

  has_and_belongs_to_many :passages

  private
  def downcase_name
    name.downcase! unless name.blank?
  end

  def spaces_to_dashes
    name.gsub!(/\s/, '-')
  end
end
