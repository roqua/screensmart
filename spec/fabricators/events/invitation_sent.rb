Fabricator(:invitation_sent, from: 'Events::InvitationSent') do
  invitation_uuid { SecureRandom.uuid }
  requester_name 'Some Doctor'
  requester_email 'some@doctor.dev'
  domain_ids ['POS-PQ']
end

Fabricator(:invitation_sent_from_roqua_epd, from: :invitation_sent) do
  requester_name 'roqua_epd'
end
