describe ResponseMailer do
  describe '#reponse_email' do
    subject { described_class.response_email(params) }

    let(:invitation_sent) { Fabricate :invitation_sent }
    let(:response) do
      invitation_accepted = AcceptInvitation.run! invitation_uuid: invitation_sent.invitation_uuid
      Response.find invitation_accepted.response_uuid
    end

    def complete_response
      %w(EL49 EL37 EL03 EL38).each do |question_id|
        Events::AnswerSet.create!(
          response_uuid: response.uuid,
          question_id: question_id,
          answer_value: 1
        )
      end
    end

    before do
      complete_response
    end

    context 'valid params' do
      let(:params) do
        {
          requester_email: invitation_sent.requester_email,
          response: response,
          invitation_sent_at: Time.zone.now
        }
      end

      it 'is sent to the to address' do
        expect(subject.to).to eq [params[:requester_email]]
      end

      it 'contains a link to show the filled in questionnaires' do
        expect(subject.html_part.body.encoded).to include(
          "http://test_host/show?showSecret=#{params[:response].show_secret}"
        )
      end

      it 'contains a response report pdf as attachment' do
        expect(subject.attachments.count).to eq(1)
      end
    end
  end
end
