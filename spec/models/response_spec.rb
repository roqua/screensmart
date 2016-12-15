describe Response do
  let(:domain_ids) { ['POS-PQ', 'NEG-PQ'] }
  let(:invitation_sent) { Fabricate :invitation_sent, domain_ids: domain_ids }
  let(:response) do
    invitation_accepted = AcceptInvitation.run! invitation_uuid: invitation_sent.invitation_uuid
    Response.find invitation_accepted.response_uuid
  end

  def complete_response(domain_id)
    Events::AnswerSet.create! response_uuid: response.uuid,
                              domain_id: domain_id,
                              question_id: 'enough_answers_to_be_done',
                              answer_value: 1
  end

  describe '#next_question' do
    it 'returns the next question from the R package' do
      expect(response.next_question.id).to start_with('EL')
    end

    it 'is nil when done' do
      complete_response(domain_ids[0])
      complete_response(domain_ids[1])
      expect(response.next_question).to be_nil
    end
  end

  describe '#questions' do
    context 'when not done testing' do
      it 'contains all answered questions plus the next one' do
        Events::AnswerSet.create!(response_uuid: response.uuid,
                                  domain_id: domain_ids[0],
                                  question_id: 'EL02',
                                  answer_value: 2)
        response.questions.map(&:id).each do |id|
          expect(id).to start_with('EL')
        end
      end
    end

    context 'when done testing' do
      it 'contains all answered questions' do
        complete_response(domain_ids[0])
        complete_response(domain_ids[1])
        expect(response.questions.map(&:id)).to eq %w(enough_answers_to_be_done enough_answers_to_be_done)
      end
    end
  end

  describe '#next_domain_response' do
    it 'returns the next domain response' do
      expect(response.next_domain_response.domain_id).to eq(domain_ids[0])
    end

    it 'is nil when done' do
      complete_response(domain_ids[0])
      complete_response(domain_ids[1])
      expect(response.next_domain_response).to be_nil
    end
  end

  describe '#next_domain_id' do
    it 'returns the next domain_id' do
      expect(response.next_domain_id).to eq(domain_ids[0])
      complete_response(domain_ids[0])
      expect(response.next_domain_id).to eq(domain_ids[1])
    end

    it 'is nil when done' do
      complete_response(domain_ids[0])
      complete_response(domain_ids[1])
      expect(response.next_domain_id).to be_nil
    end
  end
end
