class PaginasController < ApplicationController
  before_action :authenticate_usuario!, except: [:inicio]
 
  def inicio
   
  end

end
