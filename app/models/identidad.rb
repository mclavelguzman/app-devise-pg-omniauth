class Identidad < ActiveRecord::Base
  belongs_to :usuario
  validates_presence_of :uid, :proveedor
  validates_uniqueness_of :uid, :scope => :proveedor

  def self.find_for_oauth(auth)
    find_or_create_by(uid: auth.uid, proveedor: auth.provider)
  end
end  