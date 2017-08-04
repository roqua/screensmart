namespace :test_pdf do
  desc 'Generate and open a PDF for the last finished response'
  task generate: :environment do
    filename = Rails.root.join('tmp', 'test.pdf')
    uuid = Events::ResponseFinished.last.response_uuid
    response = Response.find(uuid)
    pdf = ResponseReport.new(response)
    pdf.render_file filename
    puts "Generated PDF report: #{filename}"
    system %(open "#{filename}")
  end
end
