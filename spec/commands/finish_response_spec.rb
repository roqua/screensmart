describe FinishResponse do
  let!(:invitation_uuid) { SecureRandom.uuid }
  let!(:response_uuid) { SecureRandom.uuid }
  let!(:show_secret) { SecureRandom.uuid }

  # Create a response with one answer (see VCR cassette) so we can finish the response
  before do
    Events::InvitationSent.create!(
      invitation_uuid: invitation_uuid,
      requester_email: 'requester@example.dev',
      domain_ids: ['POS-PQ']
    )

    Events::InvitationAccepted.create!(
      invitation_uuid: invitation_uuid,
      response_uuid: response_uuid,
      show_secret: show_secret
    )

    Events::AnswerSet.create!(
      response_uuid: response_uuid,
      question_id: 'enough_answers_to_be_done',
      answer_value: 1
    )

    allow(ResponseMailer).to receive_message_chain(:response_email, :deliver_now)
  end

  subject { described_class.run(params) }

  context 'with valid parameters' do
    let(:params) { { response_uuid: response_uuid } }

    it 'creates an ReponseFinished event ' do
      expect { subject }.to change { Events::ResponseFinished.count }.by(1)
    end

    it 'saves the domain results' do
      results = subject.result.results
      expect(results).to be_an(Array)
      expect(results[0].with_indifferent_access).to include(:estimate, :estimate_interpretation,
                                                            :warning, :variance)
    end

    it 'sends an email to the requester' do
      response = Response.find(response_uuid)
      invitation_sent = Events::InvitationSent.find_by(invitation_uuid: invitation_uuid)
      expect(ResponseMailer).to receive(:response_email).with invitation_sent_at: invitation_sent.created_at,
                                                              requester_email: 'requester@example.dev',
                                                              response: response
      subject
    end
  end

  context 'with invalid parameters' do
    let(:params) { { response_uuid: response_uuid } }

    context 'response_uuid is invalid' do
      it 'has an error when uuid is missing' do
        params[:response_uuid] = ''
        expect(subject.errors_on(:response_uuid)).to include('is unknown')
      end

      it 'has an error when uuid is unkown' do
        params[:response_uuid] = 'FOOBAR'
        expect(subject.errors_on(:response_uuid)).to include('is unknown')
      end
    end
  end

  context 'when response is already finished' do
    let(:params) { { response_uuid: response_uuid } }

    before do
      Events::ResponseFinished.create!(
        invitation_uuid: invitation_uuid,
        response_uuid: response_uuid
      )
    end

    it 'does not create another ResponseFinished event' do
      expect(subject.errors_on(:response_uuid)).to include('has already been finished')
    end
  end
end
