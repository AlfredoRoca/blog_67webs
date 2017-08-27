Description: spy vs double vs instance_double
Date: 27/8/2017
Categories: rspec
Summary: Spy, Double, Instance_double mejoran notablemente el rendimiento de los tests comparado con la creación de objetos reales directamente instanciando la clase o mediante FactoryGirl.
Keywords: [spy, double, instance_double, rspec]
Flags: 

#spy vs double vs instance_double

Si no es necesario usar validaciones o callbacks propias de los modelos basados en ActiveRecord puede crearse falsos objetos. 

`spy`: crea un objeto false que es devuelto ante la llamada de cualquier método. Permite definir las respuestas para cualqueir método.

`double`: igual que `spy` pero dispara error si no se ha declarado previamente el método llamado.

`instance_double`: igual que double pero sólo permite definir métodos que existan en la clase.

Ejemplos (sobre una aplicación Rails que tiene definida la clase User)

    2.4.0 :001 > require 'rspec/mocks/standalone'
     => false 

##Creación del `spy`

    2.4.0 :002 > user_spy = spy(User, cualquier_cosa: 'eiii, hola')
     => #<Double User(id: integer, email: string, encrypted_password: string, reset_password_token: string, reset_password_sent_at: datetime, remember_created_at: datetime, sign_in_count: integer, current_sign_in_at: datetime, last_sign_in_at: datetime, current_sign_in_ip: inet, last_sign_in_ip: inet, created_at: datetime, updated_at: datetime, firstname: string, lastname: string, group_id: integer, deputy: boolean, tokens: json)> 

Llamada a un método definido, devuelve el valor declarado

    2.4.0 :003 > user_spy.cualquier_cosa
     => "eiii, hola" 

Llamada a un método no definido, devuelve el objeto

    2.4.0 :004 > user_spy.otra_cosa
     => #<Double User(id: integer, email: string, encrypted_password: string, reset_password_token: string, reset_password_sent_at: datetime, remember_created_at: datetime, sign_in_count: integer, current_sign_in_at: datetime, last_sign_in_at: datetime, current_sign_in_ip: inet, last_sign_in_ip: inet, created_at: datetime, updated_at: datetime, firstname: string, lastname: string, group_id: integer, deputy: boolean, tokens: json)> 

##Creación del `double`

    2.4.0 :005 > user_double = double(User, mi_metodo: "mi metodo")
     => #<Double User(id: integer, email: string, encrypted_password: string, reset_password_token: string, reset_password_sent_at: datetime, remember_created_at: datetime, sign_in_count: integer, current_sign_in_at: datetime, last_sign_in_at: datetime, current_sign_in_ip: inet, last_sign_in_ip: inet, created_at: datetime, updated_at: datetime, firstname: string, lastname: string, group_id: integer, deputy: boolean, tokens: json)> 

Llamada a un método definido, devuelve el valor declarado

    2.4.0 :006 > user_double.mi_metodo
     => "mi metodo" 

Llamada a un método no declarado, dispara error

    2.4.0 :007 > user_double.otro_metodo
    RSpec::Mocks::MockExpectationError: #<Double User(id: integer, email: string, encrypted_password: string, reset_password_token: string, reset_password_sent_at: datetime, remember_created_at: datetime, sign_in_count: integer, current_sign_in_at: datetime, last_sign_in_at: datetime, current_sign_in_ip: inet, last_sign_in_ip: inet, created_at: datetime, updated_at: datetime, firstname: string, lastname: string, group_id: integer, deputy: boolean, tokens: json)> received unexpected message :otro_metodo with (no args)
        from (irb):7


##Creación del `instance_double` con un método declarado en la clase

    2.4.0 :008 > user_verified = instance_double(User, fullname: "Leonardo da Vinci")
     => #<InstanceDouble(User) (anonymous)> 

Llamada a un método definido, devuelve el valor declarado

    2.4.0 :009 > user_verified.fullname
     => "Leonardo da Vinci" 

Llamada a un método no declarado, dispara error

    2.4.0 :010 > user_verified.otro_metodo
    RSpec::Mocks::MockExpectationError: #<InstanceDouble(User) (anonymous)> received unexpected message :otro_metodo with (no args)
        from (irb):10

Creación del `instance_double` con un método NO declarado en la clase, dispara error

    2.4.0 :011 > user_verified = instance_double(User, name: "Leonardo da Vinci")
    RSpec::Mocks::MockExpectationError: the User class does not implement the instance method: name. Perhaps you meant to use `class_double` instead?
        from (irb):11

Benchmarking:

    gem install benchmark-ips

`rails_app/benchmarking.rb`

    require 'active_record'
    require 'rspec/mocks/standalone'
    require 'benchmark/ips'
    require 'factory_girl'

    FactoryGirl.find_definitions

    root_path = File.expand_path(File.dirname(__FILE__))

    # load models
    %w(application_record group ).each do |f|
      require "#{root_path}/app/models/#{f}.rb"
    end

    # defined here to avoid Devise
    class User < ApplicationRecord
      belongs_to :group
    end

    # Setup conexion bbdd
    database_configuration_file = "#{root_path}/config/database.yml"

    if File.exist?(database_configuration_file)
      dbconfig = YAML.load_file(database_configuration_file)
      ActiveRecord::Base.establish_connection dbconfig['development']
    else
      puts "Database configuration file not found"
    end

    Benchmark.ips do |bm|
      bm.report("spy") { spy(User, id: 1) }
      bm.report("double") { double(User, id: 1) }
      bm.report("verifying double") { instance_double(User, id: 1) }
      bm.report("actual object") { User.new(id: 1, email: "a@a.com") }
      bm.report("via factorygirl") { FactoryGirl.build(:user, id: 1) }
      bm.compare!
    end

Resultados:

    Warming up --------------------------------------
                     spy     3.063k i/100ms
                  double     3.030k i/100ms
        verifying double     1.339k i/100ms
           actual object     1.143k i/100ms
         via factorygirl   504.000  i/100ms
    Calculating -------------------------------------
                     spy     29.417k (±39.3%) i/s -    110.268k in   5.020941s
                  double     34.168k (±38.4%) i/s -    103.020k in   5.032407s
        verifying double     13.558k (±24.3%) i/s -     64.272k in   5.275856s
           actual object     13.159k (± 9.9%) i/s -     65.151k in   5.038510s
         via factorygirl      4.713k (±11.1%) i/s -     23.184k in   5.013952s

    Comparison:
                  double:    34167.5 i/s
                     spy:    29417.0 i/s - same-ish: difference falls within error
        verifying double:    13558.5 i/s - 2.52x  slower
           actual object:    13158.5 i/s - 2.60x  slower
         via factorygirl:     4713.3 i/s - 7.25x  slower


Nota: como no he sabido usar devise en el script he simplifcado notablemente la clase User. Por eso la diferencia en rendimiento no es notable al usar objetos reales. 

Conclusión:

Cualquiera de estas opciones es considerablemente más rápida que la creación de objectos reales (directa o con FactoryGirl).

Dentro de éstas, `instance_double` aporta mayor seguridad sin perjudicar mucho el rendimiento. En cualquier caso lo mejora respecto usar Factorygirl.



