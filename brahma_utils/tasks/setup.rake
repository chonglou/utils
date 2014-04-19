namespace :brahma do
  namespace :setup do
    desc 'MYSQL配置[路径]'
    task :mysql, [:path] do |_, args|
      args.with_defaults(path: 'config/database.yml')
      require 'brahma/config/mysql'
      Brahma::Config::Mysql.new(args[:path]).setup!
    end

    desc 'REDIS配置'
    task :redis, [:path] do |_, args|
      args.with_defaults(path: 'config/redis.yml')
      require 'brahma/config/redis'
      Brahma::Config::Redis.new(args[:path]).setup!
    end

    desc 'KEY生成'
    task :keys, [:path] do |_, args|
      args.with_defaults(path: 'config/keys.yml')
      require 'brahma/config/keys'
      Brahma::Config::Keys.new(args[:path]).setup!
    end
  end
end