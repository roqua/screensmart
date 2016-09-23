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

      it 'includes the requester name and email in the from field' do
        expect(subject.header[:from].value).to eq "#{params[:requester_name]} <noreply@roqua.nl>"
      end

      it 'contains a link to fill out the questionnaire' do
        expect(subject.body.encoded).to include("http://test_host/fillOut?invitationUUID=#{params[:invitation_uuid]}")
      end
    end
  end
end
