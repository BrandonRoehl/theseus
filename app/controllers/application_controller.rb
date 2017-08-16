class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def console
  end

  def get
      render json: params[:model].camelize.constantize.to_json
  end
end
