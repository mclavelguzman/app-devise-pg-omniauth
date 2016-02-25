class RegistrationsController < Devise::RegistrationsController

  def facebook
    @usuario = Usuario.find_for_oauth(env["omniauth.auth"], current_usuario)
 
    if @usuario.persisted? 
      sign_in_and_redirect @usuario, event: :authentication
      set_flash_message(:notice, :success, kind: "facebook".capitalize) if is_navigational_format?
    else
      session["devise.facebook_data"] = env["omniauth.auth"]
      redirect_to new_usuario_registration_url
    end
  end

  def failure
    flash[:error] = "No finalizó la autenticación con facebook."
    redirect_to new_usuario_session_url
  end

  def update_resource(resource, params)
    if current_usuario.identidades.present?
      params.delete("current_password")
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end

  protected

  def after_update_path_for(resource)
    flash[:notice] = "Su perfil ha sido actualizado con éxito."
    usuario_path(resource)
  end
  
end