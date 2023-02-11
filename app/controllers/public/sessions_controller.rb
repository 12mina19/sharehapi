# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  #before actionを設定し、public/session_controllerのcreateアクション（会員のログイン機能）が実行される前に確認を行う
  #退会していなかった場合,createアクション（顧客のログイン機能）を実行させる
  before_action :user_state, only: [:create]

  #利用停止機能
  before_action :unpermitted, only: [:create]



  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    super
  end
  #このcreateはログインすることを指す
  #ここのcreateアクションの前（before_action)で利用停止のユーザーを確認する
  #すごい細かいことを突き詰めると、管理者が利用停止にした瞬間、もしユーザがログインしたら、少しの間サイトを使えてしまう。
  #それを回避する方法もあるが、今は難しすぎる為やらない。


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
    #public/registrations#new 新規投稿画面へ
    end
  end


    # return if <ある場合でない時>
    #   <処理手順>
    # if <ある場合>
    #   <処理手順>


  # 管理者に利用停止にされた人(is_unpermitted：True)がログインできないようにする。
  def unpermitted
    @user = User.find_by(email: params[:user][:email])
    return if @user.blank?
    if @user.valid_password?(params[:user][:password]) && @user.is_unpermitted == true
    flash[:notice] = "現在アカウントは利用停止中となっております。"
    redirect_to new_user_registration_path  #public/registrations#new 新規投稿画面へ
    end
  end

end
