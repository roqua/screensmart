describe 'answering questions' do
  def answer_question(index, answer)
    within ".item:nth-child(#{index}) .question" do
      find('.option', text: answer).click
    end
  end

  def expect_last_question_to_be(text, intro_text = nil)
    within '.item:last-child' do
      expect(page).to have_content text
      expect(page).to have_content intro_text if intro_text
    end
  end

  before do
    invitation_sent = Events::InvitationSent.create! response_uuid: SecureRandom.uuid,
                                                     requester_email: 'some@doctor.dev',
                                                     domain_ids: ['POS-PQ']
    visit "/fillOut?responseUUID=#{invitation_sent.response_uuid}"
  end

  scenario 'initial intro text and answer text' do
    expect_last_question_to_be 'Vraag 1', 'Geef a.u.b. antwoord voor de afgelopen 7 dagen.'
  end

  scenario 'answering a question' do
    answer_question 1, 'Eens'
    expect_last_question_to_be 'Vraag 2'
  end

  scenario 'changing a previously answered question' do
    answer_question 1, 'Eens'
    expect_last_question_to_be 'Vraag 2'

    answer_question 1, 'Oneens'
    expect_last_question_to_be 'Vraag 3'
  end
end
