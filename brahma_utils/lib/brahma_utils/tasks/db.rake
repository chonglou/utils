namespace :brahma do
  namespace :db do
    desc '备份数据库[路径,次数]'
    task :backup, [:path, :count] do |_, args|
      require 'brahma/config/mysql'
      args.with_defaults(path: "#{Rails.root}/tmp", count: 7)
      path = args[:path]
      count = args[:count].to_i
      c = Brahma::Config::Mysql.new "#{Rails.root}/config/database.yml"
      c.p_s '开始备份数据库'
      mysql = c.load
      name = "#{path}/#{mysql[:database]}-#{Time.now.strftime '%Y%m%d%H%M%S.sql.gz'}"
      c.p_s "备份到数据库[#{name}]"
      value= `mysqldump -h #{mysql[:host]} -P #{mysql[:port]} -u #{mysql[:username]} -p#{mysql[:password]} --opt #{mysql[:database]} | gzip > #{name}`
      if $?.to_i == 0
        baks = Dir.glob("#{path}/#{mysql[:database]}-*.sql.gz").sort
        puts "当前有#{baks.size}个备份文件"
        if count >0 && baks.size > count
          0.upto(baks.size-count-1) do |i|
            f = baks[i]
            File.delete f
            c.p_s "清理备份文件[#{f}]"
          end
        end
        c.p_s '完毕'
      else
        c.p_s "备份数据库出错#{value}"
      end
    end
  end
end
