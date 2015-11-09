server '67.205.57.114', user: 'alfredo', roles: %w{web app}, primary: true, port: 53100
set :deploy_to, '/home/alfredo/rails_apps/blog_67webs'
set :use_sudo, false
set :rvm_ruby_version, '2.2.0@blog_67webs'