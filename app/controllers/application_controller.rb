class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  def set_locale
    if current_user
      I18n.locale = current_user.setting(:language)  
    elsif session[:locale]
      I18n.locale = session[:locale]
    else
      I18n.locale = :en
    end
  end

  def check_bitcoin_keys
    return true  if current_user && !current_user.encrypt_keys?
    if !current_user || !current_user.keys_loaded?
      sign_out
      return redirect_to new_user_session_path
    end
  end

  def parse_amount str
    (str.to_s.gsub(",", ".").to_f * User::UNITS[current_user.setting(:units)]).to_i
  end

end
