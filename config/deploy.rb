# config valid only for current version of Capistrano
lock '3.4.0'

# application name
set :application, 'blog'

# repo url to the project
set :repo_url, 'https://github.com/shhetri/blog.git'

namespace :environment do
    desc "Set environment variables"
    task :set_variables do
        on roles(:app) do
              puts ("--> Create enviroment configuration file")
              execute "cat /dev/null > #{fetch(:app_path)}/.env"
              execute "echo APP_DEBUG=#{fetch(:app_debug)} >> #{fetch(:app_path)}/.env"
              execute "echo APP_KEY=#{fetch(:app_key)} >> #{fetch(:app_path)}/.env"
        end
    end
end

namespace :composer do
    desc "Running Composer Install"
    task :install do
        on roles(:app) do
            within release_path do
                execute :composer, "install --no-dev"
                execute :composer, "dumpautoload"
            end
        end
    end
end

namespace :php5 do
    desc 'Restart php5-fpm'
        task :restart do
            on roles(:web) do
            execute :sudo, :service, "php5-fpm restart"
        end
    end
end

namespace :deploy do
  after :updated, "composer:install"
  after :finished, "environment:set_variables"
end

after "deploy",   "php5:restart"
