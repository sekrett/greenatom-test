# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate

  private

  def authenticate
    if bearer_token != ENV['API_BEARER_TOKEN']
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
  end

  def bearer_token
    request.headers['Authorization']&.split('Bearer ')&.last
  end
end
