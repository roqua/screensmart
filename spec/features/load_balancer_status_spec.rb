require 'spec_helper'

feature 'show loadbalancer and database status' do
  scenario 'visiting the status page while balancer member and database is up' do
    visit '/load_balancer_status'

    expect(page.status_code).to eq(200)
    expect(page.text).to eq('{"status":"ok","member":true}')
  end
end
