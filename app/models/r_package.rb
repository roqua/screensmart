# Only module that should communicate with screensmart-r.
module RPackage
  def self.question_by_key(key)
    questions.detect { |question| question['key'] == key }
  end

  def self.question_keys
    questions.map { |question| question['key'] }
  end

  def self.questions
    call('get_itembank_rdata')
  end

  def self.data_for(answers)
    raw_data = call('call_shadowcat', responses: [])
    memo = rewrite_response_hash(raw_data)

    answers.each_with_index do |_, index|
      params = { responses: [answers.take(index + 1).to_h],
                 estimate: memo[:estimate].try(:to_f),
                 variance: memo[:variance].try(:to_f) }.compact

      raw_data = call('call_shadowcat', params)

      memo = rewrite_response_hash(raw_data)
    end

    memo
  end

  def self.rewrite_response_hash(raw_data)
    { next_question_key: raw_data['key_new_item'],
      estimate: raw_data['estimate'][0].to_f,
      variance: raw_data['variance'][0].to_f,
      done: !raw_data['continue_test'] }
  end

  def self.call(function, parameters = {})
    Rails.cache.fetch(cache_key_for(function, parameters)) do
      Rails.logger.debug "Calling OpenCPU: #{function}(#{parameters})" # Only log non-cached calls

      OpenCPU.client.execute('screensmart', function, user: :system, data: parameters, convert_na_to_nil: true)
    end
  end

  def self.cache_key_for(function, parameters)
    "#{ENV['RAILS_ENV']}/R/#{function}/#{parameters}"
  end
end
