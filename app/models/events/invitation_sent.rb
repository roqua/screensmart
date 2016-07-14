module Events
  class InvitationSent < Event
    jsonb_accessor(
      :data,
      requester_email: :string,
      domain_ids: :string_array
    )
  end
end
