# Snapshot of how a response was when it was finished
class ResponseSnapshot < Response
  delegate :answer_values, :results, to: :response_finished
  delegate :warning, :estimate, :quartile, :variance, :estimate_interpretation, to: :results

  def done
    true
  end

  def response_finished
    @response_finished ||= Events::ResponseFinished.find_by response_uuid: uuid
  end
end
