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
  # and domain_ids(e.g. ['POS-PQ'])
  def self.data_for(answers, domain_ids)
    raise 'No domains given' unless domain_ids.present?

    initial_hash = normalized_shadowcat answers: [], domain: domain_ids

    # Recalculate the estimate and variance for <index> answers,
    # then recalculate it for <index + 1> answers with the previous estimate and variance,
    # repeat until done for all answers
    answers.each_with_index.inject(initial_hash) do |hash, (_, index)|
      params = { answers: [answers.take(index + 1).to_h],
                 estimate: hash[:estimate],
                 variance: hash[:variance],
                 domain: domain_ids }

      normalized_shadowcat params
    end
  end

  def self.normalized_shadowcat(params)
    normalize_shadowcat_output shadowcat(params)
  end

  def self.normalize_shadowcat_output(raw_data)
    { next_question_id: raw_data['key_new_item'],
      estimate: raw_data['estimate'][0].to_f,
      variance: raw_data['variance'][0].to_f,
      done: !raw_data['continue_test'] }
  end

  def self.shadowcat(params)
    call 'call_shadowcat', params
  end

  def self.call(function, parameters = {})
    Rails.cache.fetch(cache_key_for(function, parameters)) do
      begin
        logged_call function, parameters
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
    "#{ENV['RAILS_ENV']}/#{last_deploy_date}/#{function}/#{parameters}"
  end

  def self.last_deploy_date
    description.match(/Packaged: (?<package_date>.*);/).try(:[], :package_date)
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
