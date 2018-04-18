class AddInvitationUuidToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :invitation_uuid, :uuid
  end
end
