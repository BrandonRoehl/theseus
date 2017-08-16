class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_model, only: [:get]

  def console
  end

  def get
      render json: @model.to_json
  rescue
      render plain: 'No model can be found by that name'
  end

  private

  def set_model
    @model = params[:model].camelize.constantize
  end
end
