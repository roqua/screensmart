# Works same as Response.
#
# Uses the results stored in its ResponseFinished event instead of getting info realtime from R.
class ResponseSnapshot < Response
  delegate :answer_values, to: :response_finished
  delegate :warning, :estimate, :quartile, :variance, :estimate_interpretation, to: :results

  def done
    true
  end

  def raw_domain_results
    # TODO: rename to raw_domain_results in ResponseFinished to be able to delegate
    response_finished.results
  end

  def response_finished
    @response_finished ||= Events::ResponseFinished.find_by response_uuid: uuid
  end
end
