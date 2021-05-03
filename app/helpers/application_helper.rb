# frozen_string_literal: true

# :Application Helper:
module ApplicationHelper
  def active?(c_name, m_name)
    controller_name == c_name && action_name == m_name ? 'active' : ''
  end

  def remaining_days
    ((current_user.created_at + 1.days).to_date - Date.today).round
  end

  def check_role?(user_role)
    current_user.has_role? user_role
  end
end
