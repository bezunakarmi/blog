# config valid only for current version of Capistrano
lock '3.5.0'

# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

# application name
set :stages, ["staging", "production"]
set :default_stage, "staging"

set :application, 'blog'
set :branch,          ENV["branch"] || "master"

# repo url to the project
set :repo_url, 'https://github.com/shhetri/blog.git'

require 'date'
set :current_time, DateTime.now

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
end

after "deploy",   "php5:restart"
