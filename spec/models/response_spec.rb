describe Response do
  def r(uuid)
    Response.find uuid
  end

  let(:invitation_sent) do
    Events::InvitationSent.create!(response_uuid: SecureRandom.uuid,
                                   requester_email: 'some@doctor.dev',
                                   domain_ids: ['POS-PQ'])
  end

  let(:response)      { r(invitation_sent.response_uuid) }
  let(:done_response) do
    Events::AnswerSet.create!(response_uuid: response.uuid,
                              question_id: 'enough_answers_to_be_done',
                              answer_value: 1)
    r(invitation_sent.response_uuid)
  end

  describe '#next_question' do
    it 'returns the next question from the R package' do
      expect(response.next_question.id).to eq 'EL02'
    end

    it 'is nil when done' do
      expect(done_response.next_question).to be nil
    end
  end

  describe '#questions' do
    context 'when not done testing' do
      it 'contains all answered questions plus the next one' do
        Events::AnswerSet.create!(response_uuid: response.uuid,
                                  question_id: 'EL02',
                                  answer_value: 2)
        expect(response.questions.map(&:id)).to eq %w( EL02 EL03 )
      end
    end

    context 'when done testing' do
      it 'contains all answered questions' do
        expect(done_response.questions.map(&:id)).to eq %w( enough_answers_to_be_done )
      end
    end
  end

  describe '#answers' do
    it 'contains all answers to filled out questions' do
      Events::AnswerSet.create!(response_uuid: response.uuid,
                                question_id: 'EL02',
                                answer_value: 2)
      expect(response.answers.map(&:id)).to eq %w( EL02 )
    end
  end
end
