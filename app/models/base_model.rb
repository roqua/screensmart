class BaseModel
  include ActiveModel::Model
  include ActiveModel::Serialization
  include ActiveModel::Validations

  class RecordInvalid < RuntimeError; end

  def ensure_valid
    if valid?
      yield
    else
      raise RecordInvalid, "#{self.class} must be valid when accessing R attributes.\n" \
                                  "Errors: #{errors.full_messages}"
    end
  end

  # Finder method that ensures there are events for the given UUID
  def self.find(uuid)
    new(uuid: uuid).tap do |model|
      raise "No events for #{model.class} with UUID #{model.uuid}" unless model.events.any?
    end
  end

  def self.exists?(uuid)
    new(uuid: uuid).events.any?
  end

  # Overwrite comparison method to use `uuid` attribute
  def ==(other)
    other.instance_of?(self.class) && !uuid.nil? && other.uuid == uuid
  end
end
