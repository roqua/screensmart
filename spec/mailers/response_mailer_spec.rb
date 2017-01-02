describe ResponseMailer do
  describe '#reponse_email' do
    subject { described_class.response_email(params) }

    let(:invitation_sent) { Fabricate :invitation_sent }
    let(:response) do
      invitation_accepted = AcceptInvitation.run! invitation_uuid: invitation_sent.invitation_uuid
      Response.find invitation_accepted.response_uuid
    end

    def complete_response
      Events::AnswerSet.create! response_uuid: response.uuid,
                                question_id: 'enough_answers_to_be_done',
                                answer_value: 1
    end

    before do
      allow_any_instance_of(ResponseReport).to receive(:selected_answer_text).and_return('Ja')
    end

    context 'valid params' do
      let(:params) do
        {
          requester_email: invitation_sent.requester_email, # 'some@doctor.dev',
          show_secret: response.show_secret, # SecureRandom.uuid,
          invitation_sent_at: Time.zone.now
        }
      end

      it 'is sent to the to address' do
        expect(subject.to).to eq [params[:requester_email]]
      end

      it 'contains a link to show the filled in questionnaires' do
        expect(subject.html_part.body.encoded).to include("http://test_host/show?showSecret=#{params[:show_secret]}")
      end

      it 'contains a response report pdf as attachment' do
        complete_response
        expect(subject.attachments.count).to eq(1)
      end
    end
  end
end
