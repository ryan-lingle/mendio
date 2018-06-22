class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :bookmark, optional: true
  belongs_to :follower, class_name: "User", optional: true
end
