module Events
  class ResponseFinished < Event
    event_attributes :answer_values,
                     :demographic_info,
                     results: :array

    def self.find_by_invitation_uuid(invitation_uuid)
      where(invitation_uuid: invitation_uuid).first || raise("Couldn't find #{self} with invitation_uuid #{invitation_uuid}")
    end
  end
end
