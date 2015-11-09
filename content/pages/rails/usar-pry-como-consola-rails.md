Description: Usar pry como consola de Rails
Date: 13/7/2015
Categories: rails, pry
Summary: Mejor que irb es pry. Cuando lo pruebes no querrás otra cosa.

#Usar pry como consola de Rails

    :::ruby
    # application.rb

    config.console do
      require 'pry'
      config.console = Pry
    end
