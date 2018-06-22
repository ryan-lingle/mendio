# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :bookmark, optional: true
  belongs_to :follower, class_name: "User", optional: true
  validates_uniqueness_of :user, scope: :bookmark
end
