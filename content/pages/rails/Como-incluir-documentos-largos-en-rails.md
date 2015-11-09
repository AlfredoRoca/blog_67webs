Description: Cómo incluir textos largos en una aplicación Rails
Date: 6/11/2015
Categories: rails
Summary: Si necesitas incluir textos documentos como los términos y condiciones y además en varios idiomas, usar markdown puede facilitarte la vida.

#Cómo incluir un texto largo en tu aplicación rails

Fuente: <https://www.codefellows.org/blog/how-to-create-a-markdown-friendly-blog-in-a-rails-app>

##Cómo incluir un documento, por ejemplo, los términos y condiciones.
Una posible solución es usar el lenguaje Markdown y la gem 'redcarpet'

Añadir redcarpet al Gemfile

    => gem 'redcarpet'

    $ Bundle install

Crear helper en application_helper.rb

    :::ruby
    def markdown(text)
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
        no_intra_emphasis: true,
        fenced_code_blocks: true,  
        disable_indented_code_blocks: true)
      return markdown.render(text).html_safe
    end

En el controlador

    :::ruby
    def muestra_documento_markdown
      texto = ----- load file ----
      render <vista>
    end

En la vista
   
    :::ruby
    <%= markdown(texto) %>

