namespace :deploy do
  desc "Webs server managment."
  %w[start stop restart].each do |command|
    desc "#{command} Thin server."
    task command do
      on roles(:app) do
        # DreamHost shk-1
        within "#{current_path}" do
          execute "/home/alfredo/.rvm/wrappers/default/thin #{command} -C /etc/thin/blog_67webs.yml"
        end
      end
    end
  end
  after :published, :restart
end