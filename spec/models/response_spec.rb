describe Response do
  let(:invitation_sent) { Fabricate :invitation_sent }
  let(:response) do
    invitation_accepted = AcceptInvitation.run! invitation_uuid: invitation_sent.invitation_uuid
    Response.find invitation_accepted.response_uuid
  end

  def complete_response
    Events::AnswerSet.create! response_uuid: response.uuid,
                              question_id: 'enough_answers_to_be_done',
                              answer_value: 1
  end

  describe '#next_question' do
    it 'returns the next question from the R package' do
      expect(response.next_question.id).to eq 'EL02'
    end

    it 'is nil when done' do
      complete_response
      expect(response.next_question).to be nil
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
        complete_response
        expect(response.questions.map(&:id)).to eq %w( enough_answers_to_be_done )
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
