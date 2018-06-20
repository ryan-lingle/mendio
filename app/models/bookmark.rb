# frozen_string_literal: true

class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :donation
  has_many :notifications, dependent: :destroy
  validates_uniqueness_of :user, scope: :donation
  validates :user, presence: true
  validates :donation, presence: true
end
