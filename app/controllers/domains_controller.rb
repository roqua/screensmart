class DomainsController < ApplicationController
  def index
    @domains = RPackage.domains
    render json: @domains.as_json
  end
end
