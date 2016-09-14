module Events
  class InvitationSent < Event
    event_attributes requester_name: :string,
                     requester_email: :string,
                     domain_ids: :string_array
  end
end
