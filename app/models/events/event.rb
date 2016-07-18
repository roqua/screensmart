module Events
  class Event < ActiveRecord::Base
    validates :response_uuid, :type, :data, presence: true
    validates :response_uuid, length: { is: 36 }

    def self.event_attributes(attributes)
      jsonb_accessor :data, attributes
    end
  end
end
