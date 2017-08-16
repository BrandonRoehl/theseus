class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def console
  end
end
