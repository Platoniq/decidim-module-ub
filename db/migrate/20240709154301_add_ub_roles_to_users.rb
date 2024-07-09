# frozen_string_literal: true

class AddUbRolesToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :decidim_users, :ub_roles, :jsonb, default: []
  end
end
