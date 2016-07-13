class SendInvite < ActiveInteraction::Base
  string :requester_email
  array :domains do
    string
  end

  validates :requester_email, presence: true, email: true
  validate :validate_domains_defined_by_r_package

  def execute
    Events::InviteSent.create!(
      response_uuid: SecureRandom.uuid,
      requester_email: requester_email,
      domains: domains
    )
    # TODO: Send email(s)
  end

  private

  def validate_domains_defined_by_r_package
    return if domains.empty?
    domains_not_found = domains - RPackage.domain_ids
    domains_not_found.each do |domain_not_found|
      errors.add(:domains, "#{domain_not_found} is not a valid domain")
    end
  end
end
