# frozen_string_literal: true

# :Subscription Model for handling subscription things:
class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :plan
end
