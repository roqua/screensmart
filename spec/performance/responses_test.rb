context 'performance' do
  let(:invitation_sent) { Fabricate :invitation_sent }
  let(:response) do
    invitation_accepted = AcceptInvitation.run! invitation_uuid: invitation_sent.invitation_uuid
    Response.find invitation_accepted.response_uuid
  end

  def complete_response
    %w(EL49 EL37 EL03 EL38).each do |question_id|
      Events::AnswerSet.create!(
        response_uuid: response.uuid,
        question_id: question_id,
        answer_value: 1
      )
    end
  end

  before do
    require 'benchmark'

    complete_response
  end

  it 'takes some time' do
    time = Benchmark.measure do
      100.times do
        ResponseSerializer.new(response).as_json
      end
    end
    puts time
  end
end
