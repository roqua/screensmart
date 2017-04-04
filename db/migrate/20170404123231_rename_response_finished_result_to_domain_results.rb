class RenameResponseFinishedResultToDomainResults < ActiveRecord::Migration[5.0]
  def change
    Events::ResponseFinished.all.each do |response_finished|
      response_finished.data['domain_results'] = response_finished.data['results']
      response_finished.data.delete('results')
      response_finished.save! validate: false
    end
  end
end
