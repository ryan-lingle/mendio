class Episode < ActiveRecord::Base
  belongs_to :podcast
  has_many :donations, dependent: :destroy
  validates_presence_of :name
end
