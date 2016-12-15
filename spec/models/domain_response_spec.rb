describe DomainResponse do
  let(:invitation_sent) { Fabricate :invitation_sent }
  let(:domain_response) do
    invitation_accepted = AcceptInvitation.run! invitation_uuid: invitation_sent.invitation_uuid
    DomainResponse.find invitation_accepted.response_uuid, invitation_sent.domain_ids.first
  end

  def complete_response
    Events::AnswerSet.create! response_uuid: domain_response.uuid,
                              domain_id: invitation_sent.domain_ids.first,
                              question_id: 'enough_answers_to_be_done',
                              answer_value: 1
  end

  describe '#next_question' do
    it 'returns the next question from the R package' do
      expect(domain_response.next_question.id).to start_with('EL')
    end

    it 'is nil when done' do
      complete_response
      expect(domain_response.next_question).to be nil
    end
  end

  describe '#questions' do
    context 'when not done testing' do
      it 'contains all answered questions plus the next one' do
        Events::AnswerSet.create!(response_uuid: domain_response.uuid,
                                  domain_id: invitation_sent.domain_ids.first,
                                  question_id: 'EL02',
                                  answer_value: 2)
        domain_response.questions.map(&:id).each do |id|
          expect(id).to start_with('EL')
        end
      end
    end

    context 'when done testing' do
      it 'contains all answered questions' do
        complete_response
        expect(domain_response.questions.map(&:id)).to eq %w(enough_answers_to_be_done)
      end
    end
  end

  describe '#answers' do
    it 'contains all answers to filled out questions' do
      Events::AnswerSet.create!(response_uuid: domain_response.uuid,
                                domain_id: invitation_sent.domain_ids.first,
                                question_id: 'EL02',
                                answer_value: 2)
      expect(domain_response.answers.map(&:id)).to eq %w(EL02)
    end
  end
end
