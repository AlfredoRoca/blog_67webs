namespace :deploy do
  desc "Webs server managment."
  %w[start stop restart].each do |command|
    desc "#{command} Thin server."
    task command do
      on roles(:app) do
        # DreamHost shk-1
        within "#{current_path}" do
          execute "~/.rvm/wrappers/ruby-2.2.0@blog_67webs/thin #{command} -C /etc/thin/blog_67webs.yml"
        end
      end
    end
  end
  after :published, :restart

  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #     # Here we can do anything such as:
  #     # within release_path do
  #     #   execute :rake, 'cache:clear'
  #     # end
  #   end
  # end

end

