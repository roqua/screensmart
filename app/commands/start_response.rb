# For API use only, return invitation_uuid, send no invitation email
class StartResponse < ActiveInteraction::Base
  string :requester_name
  string :requester_email
  array :domain_ids do
    string
  end

  validates :requester_name, :requester_email, :domain_ids, presence: true
  validate :validate_domain_ids_defined_by_r_package

  def execute
    invitation_uuid = SecureRandom.uuid

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
