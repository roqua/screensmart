module Events
  class Event < ApplicationRecord
    validates :type, presence: true

    def self.event_attributes(*untyped_attributes, **typed_attributes)
      jsonb_accessor :data, *untyped_attributes, typed_attributes

      typed_attributes.each_key do |attribute|
        define_singleton_method "find_by_#{attribute}" do |value|
          records = send("with_#{attribute}", value)
          raise "Expected to find one #{self}, got #{records.count}" unless records.count == 1
          records.first
        end
      end
    end
  end
end
