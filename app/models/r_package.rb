# Only module that should communicate with screensmart-r.
module RPackage
  def self.question_by_id(id)
    questions.detect { |question| question['id'] == id }
  end

  def self.question_ids
    questions.map { |question| question['id'] }
  end

  def self.questions
    database['questions']
  end

  def self.domain_ids
    domains.map { |domain| domain['id'] }
  end

  def self.domains
    database['domains']
  end

  def self.database
    call('get_itembank_rdata')
  end

  # Retrieve a hash of attributes defined by the R package
  # for a given set of answers (e.g. 'EL02' => 1)
  #                 and domain_ids(e.g. ['POS-PQ'])
  def self.data_for(answers, domain_ids)
    raise 'No domains given' unless domain_ids.present?

    raw_data = call('call_shadowcat', answers: [], domain: domain_ids)
    memo = rewrite_response_hash(raw_data)

    hash = rewrite_response_hash raw_data
    answers.each_with_index do |_, index|
      params = { answers: [answers.take(index + 1).to_h],
                 estimate: memo[:estimate].try(:to_f),
                 variance: memo[:variance].try(:to_f),
                 domain: domain_ids }.compact

      raw_data = call('call_shadowcat', params)

      hash = rewrite_response_hash(raw_data)
    end
    hash
  end

  def self.rewrite_response_hash(raw_data)
    { next_question_id: raw_data['key_new_item'],
      estimate: raw_data['estimate'][0].to_f,
      variance: raw_data['variance'][0].to_f,
      done: !raw_data['continue_test'] }
  end

  def self.call(function, parameters = {})
    Rails.cache.fetch(cache_key_for(function, parameters)) do
      begin
        logged_call function, parameters
      rescue RuntimeError => e
        raise "Call to R failed with message: #{e.message}"
      end
    end
  end

  def self.logged_call(function, parameters)
    Rails.logger.debug "Calling OpenCPU: #{function}(#{parameters.pretty_inspect.strip})" # Only log non-cached calls

    result = OpenCPU.client.execute 'screensmart', function,
                                    user: :system, data: parameters, convert_na_to_nil: true
    Rails.logger.debug "Result: #{result.pretty_inspect.strip}"
    result
  end

  def self.cache_key_for(function, parameters)
    "#{ENV['RAILS_ENV']}/R/#{function}/#{parameters}"
  end
end
