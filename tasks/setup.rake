namespace :brahma do
  namespace :setup do
    desc 'DATABASE配置[路径]'
    task :database, [:path] do |_, args|
      args.with_defaults(path: 'config/database.yml')
      require 'brahma/config/database'
      Brahma::Config::Database.new(args[:path]).setup!
    end

    desc 'JOBBER配置'
    task :jobber, [:path] do |_, args|
      args.with_defaults(path: 'config/jobber.yml')
      require 'brahma/config/jobber'
      Brahma::Config::Jobber.new(args[:path]).setup!
    end

    desc 'KEY生成'
    task :keys, [:path] do |_, args|
      args.with_defaults(path: 'config/keys.yml')
      require 'brahma/config/keys'
      Brahma::Config::Keys.new(args[:path]).setup!
    end
  end
end