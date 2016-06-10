class ResponseValidator < ActiveModel::Validator
  def validate(response)
    @response = response # use instance variable to avoid parameter duplication

    answer_values_integers
    answer_ids_exist
    domain_ids_exist
    only_one_domain_id
  end

  private

  def answer_values_integers
    answers_with_non_integer_values = @response.answer_values.reject do |_id, value|
      value.is_a? Integer
    end

    if answers_with_non_integer_values.present?
      @response.errors.add :answer_values,
                           "must all be integers, non-integers: #{answers_with_non_integer_values}"
    end
  end

  def answer_ids_exist
    answers_with_nonexistant_ids = @response.answer_values.reject do |id, _value|
      RPackage.question_ids.include? id
    end

    if answers_with_nonexistant_ids.present?
      @response.errors.add :answer_values,
                           "must all have ids defined by R package, non-found ids: #{answers_with_nonexistant_ids}"
    end
  end

  def domain_ids_exist
    nonexistant_domains = @response.domain_ids.reject do |domain_id|
      RPackage.domain_ids.include? domain_id
    end

    if nonexistant_domains.present?
      @response.errors.add :domain_ids,
                           "must all have ids defined by R package, non-found ids: #{nonexistant_domains}"
    end
  end

  # TODO: remove when R package supports multiple domains
  def only_one_domain_id
    unless @response.domain_ids.one?
      @response.errors.add :domain_ids,
                           'should contain exactly one (to be fixed in a future version of R package)'
    end
  end
end
