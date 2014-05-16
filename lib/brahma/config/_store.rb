require 'highline/import'

module Brahma
  module Config
    ENVIRONMENTS = %w"production development test"

    class Storage
      def initialize(name)
        @name = name
      end

      def read
        YAML.load_file(@name)
      end

      def write(data)
        if File.exist?(@name)
          p_s "文件[#{@name}]已存在,如有必要请先备份"
          ok = ask('确认覆盖?(y/n): ') { |q| q.default='n' }.to_s
          if ok == 'y'
            File.delete(@name)
          else
            p_s '放弃更改'
            return
          end
        end
        File.open @name, 'w', 0400 do |file|
          file.write data.to_yaml
        end
        p_s '保存成功'
      end

      def p_s(message)
        print "\e[35;1m#{message}\e[0m\n"
      end
    end

    module_function

    def tasks(name, tasks)
      spec = Gem::Specification.find_by_name name
      tasks.each { |t| yield "#{spec.gem_dir}/tasks/#{t}.rake" }
    end
  end
end