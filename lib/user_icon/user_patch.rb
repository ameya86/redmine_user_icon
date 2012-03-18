require_dependency 'principal'
require_dependency 'user'

class User < Principal
  # 添付ファイル機能を有効にする
  acts_as_attachable

  # アイコンを持っているか？
  def has_icon?
    return Attachment.exists?(:container_id => self.id, :container_type =>'Principal')
  end
end
