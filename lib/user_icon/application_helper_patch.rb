require_dependency 'application_helper'

module UserIcon
  module ApplicationHelperPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods) # obj.method

      base.class_eval do
        alias_method_chain :avatar, :user_icon
      end
    end

    # obj.method
    module InstanceMethods
      # アップロードしたアイコンを表示
      def avatar_with_user_icon(user, options = { })
        if user && user.has_icon?
          return user_icon(user, options)
        elsif User.anonymous.has_icon?
          # 未設定時のアイコン
          return user_icon(User.anonymous, options)
        else
          # 何もない場合はオリジナルを呼ぶ
          return avatar_without_user_icon(user, options)
        end
      end
    end
  end
end

module ApplicationHelper
  # アイコンを表示
  def user_icon(user, options = {})
    size = options[:size] || 50 # 標準サイズは50x50
    html_class = options[:class] || 'gravatar'
    return image_tag(url_for({:controller => 'user_icons', :action => 'show', :user_id => user.id}), :width => size, :height => size, :class => html_class)
  end
end

ApplicationHelper.send(:include, UserIcon::ApplicationHelperPatch)
