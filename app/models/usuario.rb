class Usuario < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]
  has_many :identidades

	def self.find_for_oauth(auth, signed_in_resource = nil)
	    identidad = Identidad.find_for_oauth(auth)
	    usuario = signed_in_resource ? signed_in_resource : identidad.usuario
	 
	    if usuario.nil?
	      email = auth.info.email
	      name = auth.info.name
	      logger.debug("auth password>> #{auth.info.password}")
	      logger.debug("auth name>> #{auth.info.name}")
	      logger.debug("auth info>> #{auth.info}")
	      usuario = Usuario.find_by(email: email) if email
	 
	      if usuario.nil?
	        password = Devise.friendly_token[0,20]
	        if auth.provider == 'facebook'
	          usuario = Usuario.new(
	            email: email ? email : "#{auth.uid}@change-me.com",
	            password: password,
	            password_confirmation: password,
	            nombre: name

	          )
	        end
	      end
	      usuario.save!
	    end
	 
	    if identidad.usuario != usuario
	      identidad.usuario = usuario
	      identidad.save!
	    end
	    
	    usuario
	  end

		def email_verified?
		    if self.email
		      if self.email.split('@')[1] == 'change-me.com'
		        return false
		      else
		        return true
		      end
		    else
		      return false
	    end
	end
end
