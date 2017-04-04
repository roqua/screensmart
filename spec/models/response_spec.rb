describe Response do
  let(:domain_ids) { ['POS-PQ'] }
  let(:invitation_sent) { Fabricate :invitation_sent, domain_ids: domain_ids }
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
      expect(response.next_question.id).to start_with('EL')
    end

    it 'is nil when done' do
      complete_response
      expect(response.next_question).to be_nil
    end
  end

  describe '#results' do
    subject { response.results }
    it 'returns a DomainResult for each domain' do
      expect(subject.first).to be_a DomainResult
    end
  end

  describe '#questions' do
    context 'when not done testing' do
      it 'contains all answered questions plus the next one' do
        Events::AnswerSet.create!(response_uuid: response.uuid,
                                  question_id: 'EL02',
                                  answer_value: 2)
        response.questions.map(&:id).each do |id|
          expect(id).to start_with('EL')
        end
      end
    end

    context 'when done testing' do
      it 'contains all answered questions' do
        complete_response
        expect(response.questions.map(&:id)).to eq %w(enough_answers_to_be_done)
      end
    end
  end
end
