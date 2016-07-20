describe SendInvitation do
  let(:params) do
    { requester_email: 'requester@example.dev',
      respondent_email: 'patient@example.dev',
      domain_ids: ['POS-PQ']
    }
  end

  before do
    allow(InvitationMailer).to receive_message_chain(:invitation_email, :deliver_now)
  end

  context 'with valid parameters' do
    subject { described_class.run!(params) }

    it 'stores Invitation_sent event' do
      expect { subject }.to change{
        Events::InvitationSent.count
      }.by(1)
    end

    it 'sets a uuid' do
      expect(subject.response_uuid).to be
    end

    it 'sends the invitation' do
      allow(SecureRandom).to receive(:uuid).and_return SecureRandom.uuid # fixed value

      expect(InvitationMailer).to receive(:invitation_email).with requester_email: params[:requester_email],
                                                                  respondent_email: params[:respondent_email],
                                                                  response_uuid: SecureRandom.uuid

      subject
    end
  end

  context 'with invalid parameters' do
    subject { described_class.run(params) }

    context 'requester_email is invalid' do
      it 'has an error on requester email' do
        params[:requester_email] = 'requester'
        expect(subject).to have(2).errors_on(:requester_email)
      end
    end

    context 'domain is invalid' do
      it 'has an error on domain' do
        params[:domain_ids] = ['whatever']
        expect(subject).to have(1).errors_on(:domain_ids)
      end

      it 'has an error on empty domain_ids' do
        params[:domain_ids] = []
        expect(subject).to have(1).errors_on(:domain_ids)
      end
    end
  end
end
