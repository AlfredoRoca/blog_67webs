Description: Como cambiar el mensaje de error de una validación de modelo
Date: 26/11/2015
Categories: rails, active_record
Summary: Se puede personalizar el mensaje de error de una validación para hacerlo más humano.
Keywords: rails, active record, validación, mensaje de error

#Como cambiar el mensaje de error de una validacion de modelo


Supongamos que la validación se hace con la siguiente línea:

    :::ruby
    app/models/user.rb

    # ...
    validates_format_of :password, :with => PASSWORD_FORMAT
    # ...

Entonces, el mensaje de error personalizado debe escribirse de esta manera:

    :::ruby
    config/locales/en.yml

    en:
      activerecord:
        errors:
          models:
            user:
              attributes:
                password:
                  invalid: 'Must include uppercase & number'

Para otras validaciones, las palabras clave son:

- validates_presence_of keyword    ->  blank
- validates_length_of keyword      ->  too_short o too_long
- validates_uniqueness_of keyword  ->  taken

