describe ResponseReport do
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

  subject { described_class.new(response) }

  before do
    allow_any_instance_of(ResponseReport).to receive(:selected_answer_text).and_return('Ja')
  end

  it 'has one page' do
    expect(subject.page_number).to eq(1)
  end

  context 'the rendered pdf content' do
    let(:pdf_content) { PDF::Reader.new(StringIO.new(subject.render)).page(1).to_s }

    it 'contains the date of the response' do
      expect(pdf_content).to include('Ingevuld op')
    end
  end
end
