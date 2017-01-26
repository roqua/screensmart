describe ResponseMailer do
  describe '#reponse_email' do
    subject { described_class.response_email(params) }

    context 'valid params' do
      let(:params) do
        {
          requester_email: 'some@doctor.dev',
          show_secret: SecureRandom.uuid,
          invitation_sent_at: Time.zone.now
        }
      end

      it 'is sent to the to address' do
        expect(subject.to).to eq [params[:requester_email]]
      end

      it 'contains a link to show the filled in questionnaires' do
        expect(subject.body.encoded).to include("http://test_host/show?showSecret=#{params[:show_secret]}")
      end
    end
  end
end
