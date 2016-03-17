class ResponseSerializer < ActiveModel::Serializer
  attributes :initial_estimate, :initial_variance, :questions

  def initial_estimate
    Response.new.estimate
  end

  def initial_variance
    Response.new.variance
  end

  def questions
    object.answers.map do |key, value|
      response_so_far = object.without_answers_after(key)

      Question.find_by_key(key).as_json.merge(
        answer: {
          value: value,
          new_estimate: response_so_far.estimate,
          new_variance: response_so_far.variance
        }
      )
    end.push object.next_question
  end
end
