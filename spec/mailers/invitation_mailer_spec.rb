describe InvitationMailer do
  describe '#invitation_email' do
    subject { described_class.invitation_email(params) }

    context 'valid params' do
      let(:params) do
        {
          requester_name: 'Some Doctor',
          respondent_email: 'some@patient.dev',
          invitation_uuid: SecureRandom.uuid
        }
      end

      it 'is sent to the to address' do
        expect(subject.to).to eq [params[:respondent_email]]
      end

      it 'includes the requester name in the title' do
        expect(subject.header[:subject].value).to eq \
          "Verzoek van #{params[:requester_name]} om vragenlijst in te vullen"
      end

      it 'contains a link to fill out the questionnaire' do
        expect(subject.body.encoded).to include("http://test_host/fillOut?invitationUUID=#{params[:invitation_uuid]}")
      end
    end
  end
end
