# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :bookmark, optional: true
  belongs_to :follower, class_name: "User", optional: true

  def make_seen
    self.seen = true
  end

  def unseen?
    !(self.seen)
  end
end
