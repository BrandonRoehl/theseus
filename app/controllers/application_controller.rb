class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :set_model, only: [:get, :post]

    def console
    end

    def get
        render json: @model.to_json
    rescue
        render plain: 'No model can be found by that name'
    end

    def post
        for param in params.delete(:model)
            @model = JSON.load(param)
        end
    end

    private

    def set_model
        @model = params[:model].camelize.constantize
    end
end

