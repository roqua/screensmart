require 'csv'

namespace :export do
  desc 'Generate CSV export for completed fillouts'
  task csv: :environment do
    domain_ids = RPackage.domain_ids
    question_ids = RPackage.question_ids
    questions = RPackage.questions
    filename = File.join(Rails.root, 'tmp', 'export.csv')

    result_keys = domain_ids.map { |did| ["#{did} estimate", "#{did} variance", "#{did} quartile"] }
                            .flatten

    CSV.open(filename, 'wb', col_sep: ';') do |csv|

      csv << %w[response_uuid requested_at created_at requester_email] + result_keys + question_ids

      Events::ResponseFinished.all.each do |response_finished|
        begin
          response = Response.find(response_finished.response_uuid)
          question_hash = question_ids.map { |qid| [qid, ''] }.to_h
                                      .merge(response.answer_values)

          result_hash = result_keys.map { |e| [e, ''] }.to_h
          puts result_hash.inspect

          response.domain_results.each do |domain_result|
            puts domain_result.inspect
            result_hash["#{domain_result.domain_id} estimate"] = domain_result.estimate
            result_hash["#{domain_result.domain_id} variance"] = domain_result.variance
            result_hash["#{domain_result.domain_id} quartile"] = domain_result.domain_interpretations[0].quartile
          end

          csv << [
            response.uuid.to_s,
            response.requested_at,
            response.created_at,
            response.invitation.requester_email
          ] + result_hash.values + question_hash.values
        rescue
          next
        end
      end
    end

    puts "Generated CSV export: #{filename}"
  end
end
