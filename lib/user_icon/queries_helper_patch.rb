require_dependency 'queries_helper'

module UserIcon
  module QueriesHelperPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods) # obj.method

      base.class_eval do
        alias_method_chain :column_content, :user_icon
      end
    end

    # obj.method
    module InstanceMethods
      # チケット一覧でのユーザ名にアイコンを付ける
      def column_content_with_user_icon(column, issue)
        # 管理 => プラグイン => Redmine User Icon 設定でチェックがついている場合のみに実行する
        @show_issue_list_icon ||= Setting.plugin_redmine_user_icon['show_issue_list_icon']
        if '1' == @show_issue_list_icon
          value = column.value(issue)
          if 'User' == value.class.name
            return link_to(avatar(value, :size => "14") + value.name, {:controller => 'users', :action => 'show', :id => value.id})
          end
        end
        # ユーザ名以外はオリジナルの処理に任せる
        return column_content_without_user_icon(column, issue)
      end
    end
  end
end

QueriesHelper.send(:include, UserIcon::QueriesHelperPatch)
