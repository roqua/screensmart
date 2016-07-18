class SendInvitation < ActiveInteraction::Base
  string :requester_email
  array :domain_ids do
    string
  end

  validates :requester_email, presence: true, email: true
  validates :domain_ids, presence: true
  validate :validate_domain_ids_defined_by_r_package

  def execute
    Events::InvitationSent.create! response_uuid: SecureRandom.uuid,
                                   requester_email: requester_email,
                                   domain_ids: domain_ids
    # TODO: Send email(s)
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
