describe ResponseReport do
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

  subject { described_class.new(response) }

  before do
    allow_any_instance_of(ResponseReport).to receive(:selected_answer_text).and_return('Ja')
    complete_response
  end

  it 'has at least one page' do
    expect(subject.page_number).to be >= 1
  end

  context 'the rendered pdf content' do
    let(:page_1) { PDF::Reader.new(StringIO.new(subject.render)).page(1).to_s }
    let(:page_2) { PDF::Reader.new(StringIO.new(subject.render)).page(2).to_s }

    it 'contains the introduction text' do
      expect(page_1).to include('In de onderstaande tabel ziet u de resultaten van de ingevulde vragenlijst.')
    end

    it 'contains the date of the response' do
      expect(page_2).to include('Ingevuld op')
    end
  end
end
