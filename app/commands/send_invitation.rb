class SendInvitation < ActiveInteraction::Base
  string :requester_name
  string :requester_email
  string :respondent_email
  array :domain_ids do
    string
  end

  validates :requester_email, :respondent_email, email: true
  validates :requester_name, :requester_email, :respondent_email, :domain_ids, presence: true
  validate :validate_domain_ids_defined_by_r_package

  def execute
    invitation_uuid = SecureRandom.uuid

    InvitationMailer.invitation_email(requester_name: requester_name,
                                      respondent_email: respondent_email,
                                      invitation_uuid: invitation_uuid).deliver_now

    Events::InvitationSent.create! invitation_uuid: invitation_uuid,
                                   requester_name: requester_name,
                                   requester_email: requester_email,
                                   domain_ids: domain_ids
  end

  private

  def validate_domain_ids_defined_by_r_package
    return if domain_ids.empty?
    domain_ids_not_found = domain_ids - RPackage.domain_ids
    domain_ids_not_found.each do |domain_not_found|
      errors.add(:domain_ids, "#{domain_not_found} is not a valid domain")
    end
  end
end
