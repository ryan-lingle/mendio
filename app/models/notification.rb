# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :bookmark, optional: true
  belongs_to :follower, class_name: "User", optional: true
  belongs_to :donation, optional: true
  validate :bookmark_xor_follower

  def make_seen
    self.seen = true
  end

  def unseen?
    !(self.seen)
  end

  private

  def bookmark_xor_follower
    if bookmark.blank? && follower.blank? && donation.blank?
      errors.add(:base, "Specify a bookmark, follower, or donation not more than one")
    end
  end
end
