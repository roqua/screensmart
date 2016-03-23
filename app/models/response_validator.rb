class ResponseValidator < ActiveModel::Validator
  def validate(response)
    @response = response # avoid parameter duplication

    return if @response.answer_values.nil?
    validate_answer_values_integers
    validate_answer_keys_exist
  end

  private

  def validate_answer_values_integers
    answers_with_non_integer_values = @response.answer_values.reject do |_key, value|
      value.is_a? Integer
    end

    if answers_with_non_integer_values.present?
      @response.errors.add :answer_values,
                           "must all be integers, non-integers: #{answers_with_non_integer_values}"
    end
  end

  def validate_answer_keys_exist
    answers_with_nonexistant_keys = @response.answer_values.reject do |key, _value|
      RPackage.question_keys.include?(key)
    end

    if answers_with_nonexistant_keys.present?
      @response.errors.add :answer_values,
                           "must all have keys defined by R package, non-found keys: #{answers_with_nonexistant_keys}"
    end
  end
end
