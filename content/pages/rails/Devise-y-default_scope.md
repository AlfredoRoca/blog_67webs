Description: Devise y default_scope
Date: /9/2016
Categories: rails
Summary: Algunas acciones de Devise fallan al usar default_scope en el modelo User. Por ejemplo, la autentificación falla aunque el usuario y contraseña sean correctos.
Keywords: devise, default_scope

#Devise y default_scope en modelo User

Algunas acciones de Devise fallan al usar default_scope en el modelo User. Por ejemplo, la autentificación falla aunque el usuario y contraseña sean correctos.

Crear módulo así

    module DeviseOverrides  
      def find_for_authentication(conditions) 
        unscoped { super(conditions) }
      end

      def serialize_from_session(key, salt)
        unscoped { super(key, salt) }
      end

      def send_reset_password_instructions(attributes={})
        unscoped { super(attributes) }
      end

      def reset_password_by_token(attributes={})
        unscoped { super(attributes) }
      end

      def find_recoverable_or_initialize_with_errors(required_attributes, attributes, error=:invalid)
        unscoped { super(required_attributes, attributes, error) }
      end

      def send_confirmation_instructions(attributes={})
        unscoped { super(attributes) }
      end

      def confirm_by_token(confirmation_token)
        unscoped { super(confirmation_token) }
      end
    end

Extender el modelo User con este módulo

    class User < ActiveRecord::Base  
      # Include default devise modules. Others available are:
      # :timeoutable and :omniauthable
      devise :database_authenticatable, :registerable,
             :recoverable, :rememberable, :trackable, :validatable,
             :confirmable, :lockable

      extend DeviseOverrides       

      default_scope -> { where(is_admin: false) }

      ...

    end

