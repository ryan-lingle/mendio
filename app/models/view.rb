# frozen_string_literal: true

class View < ApplicationRecord
  belongs_to :user
  belongs_to :donation
  validates_uniqueness_of :user, scope: :donation
  validates :user, presence: true
  validates :donation, presence: true
end
