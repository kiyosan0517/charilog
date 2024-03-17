class ApplicationController < ActionController::Base
  before_action :require_login
  add_flash_types :success, :info, :warning, :danger
  unless Rails.env.development?
    rescue_from StandardError, with: :render_500
    rescue_from ActiveRecord::RecordNotFound,   with: :render_404
    rescue_from ActionController::RoutingError, with: :render_404
  end

  def render_404(error = nil)
    render template: 'errors/404.html', content_type: 'text/html', layout: 'error', status: 404
  end

  def render_500(error = nil)
    render template: 'errors/500.html', content_type: 'text/html', layout: 'error', status: 500
  end

  private

  def not_authenticated
    redirect_to root_path, danger: t('defaults.message.require_login')
  end
end
