describe InvitationMailer do
  describe '#invitation_email' do
    subject { described_class.invitation_email(params) }

    context 'valid params' do
      let(:params) do
        {
          from: 'some@doctor.dev',
          to: 'some@patient.dev',
          response_uuid: 'some_uuid'
        }
      end

      it 'is sent to the to address' do
        expect(subject.to).to eq [params[:to]]
      end

      it 'contains a link to fill out the questionnaire' do
        expect(subject.body.encoded).to include("http://test_host/fillOut?responseUUID=#{params[:response_uuid]}")
      end
    end
  end
end
