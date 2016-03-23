class BaseModel
  include ActiveModel::Model
  include ActiveModel::Serialization
  include ActiveModel::Validations

  def ensure_valid
    if valid?
      yield
    else
      raise "#{self.class} must be valid when accessing R attributes.\n" \
            "Errors: #{errors.full_messages}"
    end
  end
end
