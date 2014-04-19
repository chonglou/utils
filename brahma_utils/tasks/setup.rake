namespace :brahma do
  namespace :setup do
    desc 'MYSQL配置'
    task :mysql do
      require 'brahma/config/mysql'
      Brahma::Config::Mysql.new("#{Rails.root}/config/database.yml").setup!
    end

    desc 'REDIS配置'
    task :redis do
      require 'brahma/config/redis'
      Brahma::Config::Redis.new("#{Rails.root}/config/redis.yml").setup!
    end

    desc 'KEY生成'
    task :keys do
      require 'brahma/config/keys'
      Brahma::Config::Keys.new("#{Rails.root}/config/keys.yml").setup!
    end
  end
end