class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  #初期状態のdeviseは、サインアップ・サインイン時に「email」と「パスワード」しか受け取ることを許可されていない
  #「name」も受け取れるように記述
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
