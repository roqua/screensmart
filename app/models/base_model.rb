class BaseModel
  include ActiveModel::Model
  include ActiveModel::Serialization
  include ActiveModel::Validations

  def ensure_valid
    if valid?
      yield
    else
      raise "#{self.class} must be valid when accessing `#{caller_locations(1, 1)[0].label}`.\n" \
            "Errors: #{errors.full_messages}"
    end
  end
end
