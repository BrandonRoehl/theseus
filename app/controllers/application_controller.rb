class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def console
  end

  def get
      render json: params[:model].constantize
  end
end
