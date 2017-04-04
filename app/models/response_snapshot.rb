# Works same as Response.
#
# Uses the results stored in its ResponseFinished event instead of getting info realtime from R.
class ResponseSnapshot < Response
  delegate :domain_results, :answer_values, to: :response_finished
  delegate :warning, :estimate, :quartile, :variance, :estimate_interpretation, to: :results

  def done
    true
  end

  def response_finished
    @response_finished ||= Events::ResponseFinished.find_by response_uuid: uuid
  end
end
