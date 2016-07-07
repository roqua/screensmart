require 'application_responder'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  self.responder = ApplicationResponder
  respond_to :json

  before_action :invalidate_last_r_deploy_date_cache

  def invalidate_last_r_deploy_date_cache
    Rails.cache.delete :last_r_deploy_date
  end
end
