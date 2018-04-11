require 'csv'

namespace :export do
  desc 'Generate CSV export for completed fillouts'
  task csv: :environment do
    domain_ids = RPackage.domain_ids
    question_ids = RPackage.question_ids
    filename = Rails.root.join('tmp', 'export.csv')

    result_keys = domain_ids.map { |did| ["#{did} estimate", "#{did} variance", "#{did} quartile"] }
                            .flatten

    CSV.open(filename, 'wb', col_sep: ';') do |csv|
      csv << %w[response_uuid requested_at finished_at requester_email age gender education_level
                employment_status relationship_status] + result_keys + question_ids

      Events::ResponseFinished.all.each do |response_finished|
        begin
          # Only use answer keys present in question_ids
          answer_values = response_finished.data["answer_values"]
                                           .select { |k, _v| question_ids.include?(k) }
          question_hash = question_ids.map { |qid| [qid, ''] }.to_h
                                      .merge(answer_values)

          result_hash = result_keys.map { |e| [e, ''] }.to_h

          response_finished.data["results"].each do |domain_result|
            # Some domains have multiple interpretations (general/clinical)
            domain_id = domain_result["domain_interpretations"].keys.first.gsub("-GENERAL", "").gsub("-CLINICAL", "")
            raise "Domain id not found" unless domain_id
            result_hash["#{domain_id} estimate"] = domain_result["estimate"]
            result_hash["#{domain_id} variance"] = domain_result["variance"]
            result_hash["#{domain_id} quartile"] =
              domain_result["domain_interpretations"].map { |di| di[1]["quartile"] }
          end

          invitation_accepted = Events::InvitationAccepted.find_by(response_uuid: response_finished.response_uuid)
          invitation_sent = Events::InvitationSent.find_by(invitation_uuid: invitation_accepted.invitation_uuid)

          puts "#{response_finished.response_uuid}, " \
               "Question count: #{question_ids.length}, " \
               "Answers count: #{question_hash.length}, " \
               "Result count: #{result_hash.length}"

          csv << [
            response_finished.response_uuid.to_s,
            invitation_sent.created_at,
            response_finished.created_at,
            invitation_sent.data["requester_email"],
            response_finished.data["demographic_info"]["age"],
            response_finished.data["demographic_info"]["gender"],
            response_finished.data["demographic_info"]["education_level"],
            response_finished.data["demographic_info"]["employment_status"],
            response_finished.data["demographic_info"]["relationship_status"]
          ] + result_hash.values + question_hash.values

        # rubocop:disable Style/RescueStandardError
        rescue => e
        # rubocop:enable Style/RescueStandardError
          puts "** Error while parsing results for response_uuid #{response_finished.response_uuid} **"
          puts e.message
          next
        end
      end
    end

    puts "Generated CSV export: #{filename}"
  end
end
