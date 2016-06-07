class ResponseValidator < ActiveModel::Validator
  def validate(response)
    @response = response # use instance variable to avoid parameter duplication

    answer_values_integers
    answer_keys_exist
    domain_keys_exist
    only_one_domain_key
  end

  private

  def answer_values_integers
    answers_with_non_integer_values = @response.answer_values.reject do |_key, value|
      value.is_a? Integer
    end

    if answers_with_non_integer_values.present?
      @response.errors.add :answer_values,
                           "must all be integers, non-integers: #{answers_with_non_integer_values}"
    end
  end

  def answer_keys_exist
    answers_with_nonexistant_keys = @response.answer_values.reject do |key, _value|
      RPackage.question_keys.include? key
    end

    if answers_with_nonexistant_keys.present?
      @response.errors.add :answer_values,
                           "must all have keys defined by R package, non-found keys: #{answers_with_nonexistant_keys}"
    end
  end

  def domain_keys_exist
    nonexistant_domains = @response.domain_keys.reject do |domain_key|
      RPackage.domain_keys.include? domain_key
    end

    if nonexistant_domains.present?
      @response.errors.add :domain_keys,
                           "contains nonexistant domains: #{nonexistant_domains}"
    end
  end

  # TODO: remove when R package supports multiple domains
  def only_one_domain_key
    unless @response.domain_keys.one?
      @response.errors.add :domain_keys,
                           'can only contain one (to be fixed in a future version of R package)'
    end
  end
end
