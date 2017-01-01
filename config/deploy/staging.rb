server '64.111.99.67', user: 'deployer', roles: %w{web app}, primary: true, port: 53100
set :deploy_to, '/var/www/blog_67webs'
set :use_sudo, false
set :rvm_ruby_version, '2.2.0@blog_67webs'
set :rake_env, 'staging'
set :rails_env, 'staging'
set :deploy_user, 'deployer'

set :default_environment, {
  'PATH' => "$PATH",
  'RUBY_VERSION' => 'ruby 2.2.0',
  'GEM_HOME'     => '/home/deployer/.rvm/gems/ruby-2.2.0@blog_67webs',
  'GEM_PATH'     => '/home/deployer/.rvm/gems/ruby-2.2.0@blog_67webs',
  'BUNDLE_PATH'  => '/home/deployer/.rvm/gems/ruby-2.2.0@blog_67webs'  # If you are using bundler.
}
