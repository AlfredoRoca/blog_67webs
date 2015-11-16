Description: Como validar condicionalmente modelos en Rails
Date: 7/11/2014
Categories: rails
Summary: Validar registros según convenga
Keywords: rails, validacion condicional modelos

#Como validar condicionalmente modelos en Rails

##Escenario:

Devise para autentificación de usuarios
El usuario se registra con su email.
Para realizar actividad debe completar su perfil.
El modelo valida la presencia de varios campos como, por ejemplo, el nombre completo (fullname).
La validación sólo debe realizarse cuando se actualiza (update) el modelo, no al crearlo (create) puesto que se crea mediante el registro (durante el cual únicamente se introduce el email y la contraseña).
Caso especial es la contraseña. Hay que tener en cuenta que ésta se cambia en un formulario exclusivo. Por tanto, la validación de los otros campos no debe aplicarse en este caso.

##Solución:

Usaremos las clausulas ```:on``` e ```:if```

    :::ruby
    class User < ActiveRecord::Base
      devise :database_authenticatable, :registerable, :confirmable
      validates :email, presence: true, uniqueness: true
      validates :fullname, presence: true, on: :update, if: :not_changing_password?

      def not_changing_password?
        !changed.include?("encrypted_password")
      end
    end