describe 'answering questions' do
  def answer_question(index, answer)
    within ".question:nth-child(#{index})" do
      find('.option', text: answer).click
    end
  end

  def expect_last_question_to_be(text, intro_text = nil)
    within(:xpath, '(//div[@class="question"])[last()]') do
      expect(page).to have_content text
      expect(page).to have_content intro_text if intro_text
    end
  end

  def fill_out_url
    "/fillOut?invitationUUID=#{invitation_sent.invitation_uuid}"
  end

  def complete_response
    # Question 1 = 'Oneens' means done in VCR cassette
    answer_question 1, 'Oneens'
    answer_question 2, 'Oneens'
    answer_question 3, 'Oneens'
    answer_question 4, 'Oneens'
    expect_last_question_to_be 'Ik heb vaak het gevoel dat andere mensen mij bekijken of het over mij hebben'

    click_on 'Afronden'
  end

  let(:invitation_sent) { Fabricate :invitation_sent }

  before { visit fill_out_url }

  scenario 'initial intro text and answer text' do
    expect_last_question_to_be 'Mijn denken voelt verward, door elkaar gehaald of op een of andere manier verstoord.'
  end

  scenario 'answering a question' do
    answer_question 1, 'Eens'
    expect_last_question_to_be 'Mijn gedachten zijn soms zo sterk dat ik ze bijna kan horen'
  end

  scenario 'finishing' do
    expect_last_question_to_be 'Mijn denken voelt verward, door elkaar gehaald of op een of andere manier verstoord'

    # Question 1 = 'Eens' means there is a next question in VCR cassette
    # answer_question 1, 'Eens'
    # expect_last_question_to_be 'Mijn gedachten zijn soms zo sterk dat ik ze bijna kan horen'

    complete_response

    expect(page).to_not have_content 'Vraag 1'
    expect(page).to have_content 'Bedankt voor het invullen'
  end

  scenario 'starting over' do
    answer_question 1, 'Eens'
    expect_last_question_to_be 'Mijn gedachten zijn soms zo sterk dat ik ze bijna kan horen'

    visit fill_out_url

    expect_last_question_to_be 'Mijn denken voelt verward, door elkaar gehaald of op een of andere manier verstoord'
  end

  scenario 'viewing a completed response' do
    complete_response

    visit "/show?showSecret=#{Events::InvitationAccepted.last.show_secret}"

    # It shows the question title
    expect(page).to have_content 'Het kost mij moeite om me te concentreren op een gedachte tegelijk'
    # It shows the chosen option
    expect(page).to have_content 'Oneens'
  end
end
