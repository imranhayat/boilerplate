# frozen_string_literal: true

# :Plan Model:
class Plan < ApplicationRecord
  belongs_to :product
  validates :nickname, uniqueness: true
  has_many :subscriptions, dependent: :destroy

end
