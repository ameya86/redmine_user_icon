ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'user_icons' do |user_icon|
    user_icon.connect 'users/:user_id/icon', :action => 'show' 
    user_icon.connect 'users/icon/:action/:user_id'
  end
end
