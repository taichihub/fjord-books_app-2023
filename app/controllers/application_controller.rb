# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_locale

  def change_locale
    locale = params[:locale].to_s.strip.to_sym
    locale = I18n.default_locale unless I18n.available_locales.include?(locale)
    session[:locale] = locale
    redirect_to request.referer || root_url
  end

  private

  def set_locale
    I18n.locale = session[:locale] || I18n.default_locale
  end
end
