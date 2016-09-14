Fabricator(:invitation_sent, from: 'Events::InvitationSent') do
  invitation_uuid { SecureRandom.uuid }
  requester_name 'Some Doctor'
  requester_email 'some@doctor.dev'
  domain_ids ['POS-PQ']
end
