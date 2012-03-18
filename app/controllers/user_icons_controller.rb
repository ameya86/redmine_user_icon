class UserIconsController < ApplicationController
  helper :attachments
  include AttachmentsHelper

  before_filter :required_auth, :only => [:upload, :destroy]

  # アイコンを表示する
  def show
    if params[:user_id].blank?
      render_404
      return
    end

    attachment = Attachment.find(:first, :conditions => ['container_id = ? and container_type = ?', params[:user_id], 'Principal'])

    if attachment
      send_file(attachment.diskfile, :filename => filename_for_content_disposition(attachment.filename),
                                     :type => detect_content_type(attachment),
                                     :disposition => (attachment.image? ? 'inline' : 'attachment'))
    else
      render_404
    end
  end

  # アイコンを更新する
  def upload
    if request.post? && params[:attachments]
      # 古いアイコンを控えておき、成功時に消す
      old_attachment_ids = @user.attachment_ids

      # イメージファイルでないファイルは使わない
      no_image = false
      params[:attachments].reject! do |number, attachment|
        no_image ||= !(/^image\// =~ detect_content_type(attachment[:file]))
      end

      attachments = Attachment.attach_files(@user, params[:attachments])

      # 失敗時のメッセージを表示
      render_attachment_warning_if_needed(@user)
      flash[:error] = l(:error_user_icon_content_type_not_images) if no_image

      # 成功時は古いアイコンを削除する
      if attachments[:unsaved].blank? && attachments[:files].present?
        Attachment.destroy_all(['id in (?)', old_attachment_ids])
      end

      redirect_to back_url
    end
  end

  # アイコンを削除する
  def destroy
    if request.post? && @user
      Attachment.destroy_all(['container_id = ? and container_type = ?', @user.id, 'Principal'])
    end

    redirect_to back_url
  end

  private
  # 自身の編集か、adminでない場合は403にする
  def required_auth
    if params[:user_id]
      @user = User.find_by_id(params[:user_id])
      unless @user
        render_404
        return
      end

      if @user.id != User.current.id && !User.current.admin?
        render_403
        return
      end
    else
      @user = User.current
    end
  end

  # 前のページに戻る
  # 指定がなければとりあえず個人設定画面に飛ぶ
  def back_url
    return (params[:back_url].present?)? params[:back_url] : {:controller => 'my', :action => 'account'}
  end

  # Copy from AttachmentsController
  def detect_content_type(attachment)
    content_type = attachment.content_type
    if content_type.blank?
      content_type = Redmine::MimeType.of(attachment.filename)
    end
    content_type.to_s
  end
end
