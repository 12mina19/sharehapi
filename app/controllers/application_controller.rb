class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    if admin_signed_in?
      #if resource.is_a?(Admin)…resource がAdmin のインスタンスであれば true を返すという処理
      admin_path
      #投稿一覧（管理者TOP）画面へ
    else customer_signed_in?
      root_path
    end
  end

  def after_sign_out_path_for(resource)
    if resource == :admin
      new_admin_session_path#管理者ログイン画面へ
    else
      root_path#エンドユーザー側のTOP画面へ
    end
  end


  protected

  #初期状態のdeviseは、サインアップ・サインイン時に「email」と「パスワード」しか受け取ることを許可されていない
  #「name」も受け取れるように記述
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
