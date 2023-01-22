# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  #before actionを設定し、public/session_controllerのcreateアクション（会員のログイン機能）が実行される前に確認を行う
  #退会していなかった場合,createアクション（顧客のログイン機能）を実行させる
  before_action :user_state, only: [:create]

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  protected

# 退会しているかを判断するメソッド
  def user_state
    @user = User.find_by(email: params[:user][:email])
    #入力されたemailからアカウントを1件取得
    return if !@user
    #アカウントを取得できなかった場合、このメソッドを終了
    #そもそもemailがヒットしなければ、退会どころか、そもそも登録したこともない
    if @user.valid_password?(params[:user][:password]) && @user.is_deleted == true
    #&&は「and」
    #論理積( AND )は演算子 && の左辺及び右辺の条件式が共に true の場合のみ全体の式の評価が true となり
    #「取得したアカウントのパスワードと入力されたパスワードが一致しているかを判別」かつ「退会済」だった場合
    #.valid_password?…　「？」があるメソッドは、自動的にtrueとfalseが認識される。だからあえて＝＝trueなどを書く必要はない
    #.valid_password?の部分が、trueでもfalseでも、「.is_deleted == true」の場合は新規登録に戻る必要がある。
    redirect_to new_user_registration_path
    end
  end
  
  #管理者に利用停止にされた人(is_unpermitted：True)がログインできないようにしたい。新規投稿（同じメールアドレスはダメ）はregitrationの画面に書く。

end
