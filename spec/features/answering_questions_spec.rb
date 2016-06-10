describe 'answering questions' do
  def answer_question(index, answer)
    within ".item:nth-child(#{index}) .question" do
      find('.option', text: answer).click
    end
  end

  def expect_last_question_to_be(text)
    within '.item:last-child' do
      expect(page).to have_content text
    end
  end

  before { visit '/fill_out?domainIds=POS-PQ' }

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
