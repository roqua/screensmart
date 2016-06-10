class ResponseValidator < ActiveModel::Validator
  def validate(response)
    @response = response # use instance variable to avoid parameter duplication

    answer_values_integers
    question_ids_in_domains if @response.domain_ids.present?
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

  def question_ids_in_domains
    answers_with_nonexistant_ids = @response.answer_values.reject do |id, _value|
      question_ids_for_domains.include? id
    end

    if answers_with_nonexistant_ids.present?
      @response.errors.add :answer_values,
                           "must all be related to domains #{@response.domain_ids}," \
                           "non-found ids: #{answers_with_nonexistant_ids}"
    end
  end

  def question_ids_for_domains
    questions_for_domains.map { |question| question['id'] }
  end

  def questions_for_domains
    RPackage.questions.select do |question|
      @response.domain_ids.include? question['domain_id']
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
