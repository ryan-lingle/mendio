class Episode < ActiveRecord::Base
  belongs_to :podcast
  has_many :donations, dependent: :destroy
  validates_presence_of :name
  include PgSearch
  pg_search_scope :search,
    against: [ :name ],
    using: {
      tsearch: { prefix: true }
    }
end
