require 'redmine'
require 'user_icon/application_helper_patch'
require 'user_icon/queries_helper_patch'
require 'user_icon/user_patch'
require 'user_icon/hook'

Redmine::Plugin.register :redmine_user_icon do
  name 'Redmine User Icon plugin'
  author 'OZAWA Yasuhiro'
  description 'Set user icon'
  version '0.0.1'
  url 'https://github.com/ameya86/redmine_user_icon'
  author_url 'http://blog.livedoor.jp/ameya86/'

  settings :default => {
             'show_issue_list_icon' => '1'
           }, :partial => 'user_icons/settings'
end
