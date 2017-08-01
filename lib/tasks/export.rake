require 'csv'

namespace :export do
  desc 'Generate CSV export for completed fillouts'
  task csv: :environment do
    question_ids = RPackage.question_ids
    questions = RPackage.questions
    filename = File.join(Rails.root, 'tmp', 'export.csv')

    CSV.open(filename, "wb", col_sep: ";") do |csv|
      csv << %w[response_uuid requested_at created_at requester_email domain_id estimate variance quartile] + question_ids

      Events::ResponseFinished.all.each do |response_finished|
        response = Response.find(response_finished.response_uuid)
        response.domain_results.each do |domain_result|
          question_hash = question_ids.map { |qid| [qid, ""] }.to_h
          domain_questions = questions.select { |q| q["domain_id"] == domain_result.domain_id }.map { |q| q["id"] }
          answered_questions = response.answer_values.select { |k, av| domain_questions.include?(k) }
          question_hash = question_hash.merge(answered_questions)

          csv << [
            response.uuid.to_s,
            response.requested_at,
            response.created_at,
            response.invitation.requester_email,
            domain_result.domain_id,
            domain_result.estimate,
            domain_result.variance,
            domain_result.domain_interpretations[0].quartile
          ] + question_hash.values
        end
      end
    end

    puts "Generated CSV export: #{filename}"
  end
end
