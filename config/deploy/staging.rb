server '67.205.57.114', user: 'deployer', roles: %w{web app}, primary: true, port: 53100
set :deploy_to, '/var/www/blog_67webs'
set :use_sudo, false
set :rvm_ruby_version, '2.2.0@blog_67webs'
set :rake_env, 'staging'
set :rails_env, 'staging'

set :default_environment, {
  'PATH' => "$PATH",
  'RUBY_VERSION' => 'ruby 2.2.0',
  'GEM_HOME'     => '/home/alfredo/.rvm/gems/ruby-2.2.0',
  'GEM_PATH'     => '/home/alfredo/.rvm/gems/ruby-2.2.0',
  'BUNDLE_PATH'  => '/home/alfredo/.rvm/gems/ruby-2.2.0'  # If you are using bundler.
}
