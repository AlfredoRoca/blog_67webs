Description: NestaCMS
Date: 9/9/2017
Categories: nesta
Summary: Steps to create a new blog for programmers.
Keywords: nesta
Flags:

#A new blog for programmers with NestaCMS

    rvm gemset create my_new_blog
    rvm gemset use my_new_blog
    gem install nesta
    nesta new my_new_blog
    cd my_new_blog
    bundle install
    nesta demo:content
    mr-sparkle config.ru

edit config.yml (title, subtitle, author, content, ...)

    nesta theme:install https://github.com/gma/nesta-theme-slate


