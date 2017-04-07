describe FinishResponse do
  let!(:invitation_uuid) { SecureRandom.uuid }
  let!(:response_uuid) { SecureRandom.uuid }
  let!(:show_secret) { SecureRandom.uuid }
  let(:demographic_info) do
    { age: 18,
      education_level: 'vmbo',
      employment_status: 'fulltime',
      gender: 'female',
      relationship_status: 'living_together' }
  end

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

  context 'with valid parameters' do
    subject { described_class.run!(params) }
    let(:params) { { response_uuid: response_uuid, demographic_info: demographic_info } }

    it 'creates an ReponseFinished event' do
      expect { subject }.to change { Events::ResponseFinished.count }.by(1)
    end

    it 'saves the domain results' do
      results = subject.results
      expect(results).to be_an(Array)
      expect(results[0].with_indifferent_access).to include(:estimate, :estimate_interpretation,
                                                            :warning, :variance)
    end

    it 'saves the demographic info' do
      demographic_info = subject.demographic_info
      expect(demographic_info).to be_a(Hash)
      expect(demographic_info.with_indifferent_access).to include(:gender, :age, :education_level,
                                                                  :employment_status, :relationship_status)
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
    subject { described_class.run(params) }
    let(:params) { { response_uuid: response_uuid, demographic_info: demographic_info } }

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

    context 'when response is already finished' do
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
end
