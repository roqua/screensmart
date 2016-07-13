module Events
  class InvitationSent < Event
    jsonb_accessor(
      :data,
      requester_email: :string,
      domains: :string_array
    )
  end
end
