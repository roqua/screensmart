class Invitation < BaseModel
  attr_accessor :uuid

  delegate :domain_ids, :requester_email, :requester_name, to: :invitation_sent

  def invitation_sent
    @invitation_sent ||= Events::InvitationSent.find_by_invitation_uuid uuid
  end

  def requested_at
    invitation_sent.created_at
  end

  def self.find_by_response_uuid(response_uuid)
    invitation_accepted = Events::InvitationAccepted.find_by! response_uuid: response_uuid
    find invitation_accepted.invitation_uuid
  end

  def events
    Events::Event.where invitation_uuid: uuid
  end
end
