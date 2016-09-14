module Events
  class InvitationAccepted < Event
    event_attributes show_secret: :string

    def self.find_by_show_secret(show_secret)
      with_show_secret(show_secret).first || raise("Couldn't find #{self} with show_secret #{show_secret}")
    end
  end
end
