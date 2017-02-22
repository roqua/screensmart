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

  # Retrieve a hash of attributes defined by the R packag for a given set of answers (e.g. 'EL02' => 1)
  # and domain_ids(e.g. ['POS-PQ'])
  def self.data_for(answers, domain_ids)
    Appsignal.instrument "RPackage.data_for", "Getting next question for #{answers.count} answers" do
      raise 'No domains given' unless domain_ids.present?

      # TODO: Allow screensmart-r's call_shadowcat function to handle
      #       multiple domains, which will allow us to simply return
      #       its return value here, greatly reducing complexity.
      domain_results = domain_ids.map do |domain_id|
        data_for_domain(answers, domain_id)
      end

      { next_question_id: domain_results.find { |dr| !dr[:done] }.try(:[], :next_question_id),
        done: domain_results.all? { |domain| domain[:done] },
        domain_results: domain_results_hash(domain_ids, domain_results) }
    end
  end

  def self.domain_results_hash(domain_ids, domain_results)
    domain_ids.zip(domain_results).map do |domain_id, domain|
      [domain_id, domain.slice(:estimate, :variance, :estimate_interpretation, :quartile, :warning)]
    end.to_h
  end

  def self.data_for_domain(answers, domain_id)
    accumulator = normalized_shadowcat answers: [], domain: domain_id

    answers_in_domain = filter_answers_by_domain(answers, domain_id)

    # Recalculate the estimate and variance for <index> answers,
    # then recalculate it for <index + 1> answers with the previous estimate and variance,
    # repeat until done for all answers
    answers_in_domain.each_with_index.inject(accumulator) do |hash, (_, index)|
      params = { answers: [answers_in_domain.take(index + 1).to_h],
                 estimate: hash[:estimate],
                 variance: hash[:variance],
                 domain: domain_id }

      normalized_shadowcat params
    end
  end

  def self.filter_answers_by_domain(answers, domain_id)
    answers.select do |question_id, _|
      domain_id_for_question_id(question_id) == domain_id
    end
  end

  def self.domain_id_for_question_id(id)
    find_question(id)['domain_id']
  end

  def self.find_question(id)
    questions.find { |q| q['id'] == id } || raise("No question with id #{id}")
  end

  def self.normalized_shadowcat(params)
    # Allow this function to be called with sensible params by denormalizing them here
    denormalized_params = params.tap do |p|
      # screensmart-r requires an array 'domain' value, although it can currently only contain one value
      p[:domain] = [p[:domain]]
    end

    normalize_shadowcat_output shadowcat(denormalized_params)
  end

  def self.normalize_shadowcat_output(raw_data)
    { next_question_id: raw_data['key_new_item'],
      estimate: raw_data['estimate'][0].to_f,
      variance: raw_data['variance'][0].to_f,
      estimate_interpretation: raw_data['estimate_interpretation'],
      quartile: raw_data['quartile'],
      warning: raw_data['warning'],
      done: !raw_data['continue_test'] }
  end

  def self.shadowcat(params)
    call 'call_shadowcat', params
  end

  def self.call(function, parameters = {})
    Rails.cache.fetch(cache_key_for(function, parameters)) do
      begin
        Appsignal.instrument "screensmart-r.#{function}", "Non-cached call to #{function}" do
          logged_call function, parameters
        end
      rescue OpenCPU::Errors::AccessDenied
        explain_opencpu_configuration
      rescue RuntimeError => e
        raise "Call to R failed with message: #{e.message}"
      end
    end
  end

  def self.explain_opencpu_configuration
    raise 'OpenCPU authentication failed. Ensure' \
      'OPENCPU_ENDPOINT_URL, OPENCPU_USERNAME and OPENCPU_PASSWORD environment variables are set correctly.'
  end

  def self.logged_call(function, parameters)
    Rails.logger.debug "Calling OpenCPU: #{function}(#{parameters})" # Only log non-cached calls

    result = Client.instance.execute 'screensmart', function,
                                     user: :system, data: parameters, convert_na_to_nil: true
    Rails.logger.debug "Result: #{result}"
    result
  end

  def self.cache_key_for(function, parameters)
    # Use SHA1 hash because raw string might be too long for cache key
    Digest::SHA1.hexdigest "#{ENV['RAILS_ENV']}/#{last_deploy_date}/#{function}/#{parameters}"
  end

  def self.last_deploy_date
    Rails.cache.fetch(:last_r_deploy_date) do
      description.match(/Packaged: (?<package_date>.*);/).try(:[], :package_date)
    end
  end

  def self.description
    Client.instance.description('screensmart')
  end

  class Client < SimpleDelegator
    include Singleton

    def initialize
      @client = OpenCPU.client
      super(@client)
    end
  end
end
