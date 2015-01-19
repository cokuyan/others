class AddUserAgentToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :user_agent, :string
    add_column :sessions, :ip_address, :string
  end
end
