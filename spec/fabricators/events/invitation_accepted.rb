Fabricator(:invitation_accepted, from: 'Events::InvitationAccepted') do
  invitation_uuid { Fabricate(:invitation_sent).invitation_uuid }
  response_uuid { SecureRandom.uuid }
end
