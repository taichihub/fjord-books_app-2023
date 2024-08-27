# frozen_string_literal: true

class LocalesController < ApplicationController
  def change
    locale = params[:locale].presence&.to_s&.strip&.to_sym || I18n.default_locale
    locale = I18n.default_locale unless I18n.available_locales.include?(locale)
    session[:locale] = locale
    redirect_to request.referer || root_url
  end
end
