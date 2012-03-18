module UserIcon
  class AccountListener < Redmine::Hook::ViewListener
    # 個人設定画面にアイコン欄を表示
    render_on :view_my_account, :partial => 'user_icons/icon'
    # ユーザ編集画面にアイコン欄を表示
    render_on:view_users_form, :partial => 'user_icons/icon'
  end
end
