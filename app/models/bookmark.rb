# frozen_string_literal: true

class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :episode
  has_many :notifications, dependent: :destroy
  validates_uniqueness_of :user, scope: :episode
  validates :user, presence: true
  validates :episode, presence: true
end
