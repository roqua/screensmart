describe 'sending invitations' do
  def fill_out_placeholder(placeholder, value)
    find("input[placeholder='#{placeholder}']").set value
  end

  def fill_out_all_fields
    fill_out_placeholder 'e-mail respondent', 'some@patient.dev'
    fill_out_placeholder 'uw volledige naam', 'Some Doctor'
    fill_out_placeholder 'uw e-mail', 'some@doctor.dev'
    find('.domain-label', text: 'Positieve symptomen voor psychose').click
  end

  before { visit '/' }

  scenario 'filling out all fields and submitting the form' do
    fill_out_all_fields

    click_on 'Verstuur uitnodiging'
    expect(page).not_to have_css '.error'
  end

  scenario 'not filling out all fields' do
    fill_out_all_fields
    fill_out_placeholder 'e-mail respondent', ''

    click_on 'Verstuur uitnodiging'
    expect(page).to have_css '.error'
    expect(page).to have_content 'Vul een geldig e-mailadres in'
  end

  scenario 'entering invalid values' do
    fill_out_all_fields
    fill_out_placeholder 'e-mail respondent', 'invalid'

    click_on 'Verstuur uitnodiging'
    expect(page).to have_css '.error'
    expect(page).to have_content 'Vul een geldig e-mailadres in'
  end
end
