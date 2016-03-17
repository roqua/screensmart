class ResponseValidator < ActiveModel::Validator
  def validate(response)
    @response = response # to prevent parameter duplication

    validate_answers_integers
  end

  private

  def invalid_float_message(given_value, valid_range)
    "must be a float between #{valid_range}, #{given_value} given"
  end

  def in_float_range?(value, valid_range)
    valid_float_string?(value) && valid_range.include?(value.to_f)
  end

  # based on http://stackoverflow.com/a/1034499/2552895
  def valid_float_string?(value)
    Float(value)
  rescue
    false
  end

  def validate_answers_integers
    non_integer_answers = @response.answers.values.select do |value|
      value.to_f.to_s == value
    end

    if non_integer_answers.present?
      @response.errors.add :answers, "Answers values must all be integers, non-integers: #{non_integer_answers}"
    end
  end
end
