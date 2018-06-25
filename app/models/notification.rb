# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :bookmark, optional: true
  belongs_to :follower, class_name: "User", optional: true
  validate :bookmark_xor_follower

  def make_seen
    self.seen = true
  end

  def unseen?
    !(self.seen)
  end

  private

  def bookmark_xor_follower
    unless bookmark.blank? ^ follower.blank?
      errors.add(:base, "Specify a bookmark or a follower, not both")
    end
  end
end
