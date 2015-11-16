Description: Cómo personalizar las vistas de Nesta
Date: 9/11/2015
Categories: nesta
Summary: Así es como yo he personalizado mi blog.
Keywords: nestacms, personalizar, vistas

#Cómo personalizar las vistas de NestaCMS

Fuente: <http://nestacms.com/docs/design/editing-default-templates>

Para averiguar los nombres de los archivos (aplica igual para los temas)

    :::bash
    ls -l $(bundle show nesta)/views
    
Por ejemplo,

    :::bash
    cp $(bundle show nesta)/views/page-meta.haml views/
    
He cambiado el helper de fomateo de fecha en la línea

    :::ruby
    %time(datetime="#{page.date.to_s}" pubdate=true)= format_date_to_short(page.date)

y en ```app.rb``` he añadido

    :::ruby
    def format_date_to_short(date)
      date.strftime("%d/%m/%Y")
    end

