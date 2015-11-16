Description: Cómo abrir un popup desde rails
Date: 15/11/2015
Categories: rails
Summary: Una de las formas de dar notificaciones al usuario es mediante ventanas emergentes. Aquí explico cómo lo he hecho yo usando las ventanas modales de Bootstrap

#Cómo abrir un popup desde rails

En la vista donde se quiere que aparezca el popup

    <%= render 'popup_con_mensaje' %>


popup_con_mensaje.html.erb

    <!-- Modal -->
    <div class="modal" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title" id="myModalLabel"><%= t(:Modal_title) %></h4>
          </div>
          <div class="modal-body">
            <h4><%= t(:Modal_message) %></h4>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-primary" data-dismiss="modal"><%= t(:Close_modal) %></button>
          </div>
        </div>
      </div>
    </div>


En la acción del controlador que debe abrir el popup

  render :popup_con_mensaje


En bootstrap-sprockets.js

    //= require ./bootstrap/modal

Mas información en <http://getbootstrap.com/javascript/#modals>
