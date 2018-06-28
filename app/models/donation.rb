# frozen_string_literal: true

class Donation < ActiveRecord::Base
  belongs_to :user
  belongs_to :episode
  belongs_to :influencer, class_name: "User", optional: true
  has_many :views, dependent: :destroy
  has_many :user_views, through: :views, source: :user
  has_many :notifications, dependent: :destroy
  validates_presence_of [ :amount, :episode, :user ]
end
