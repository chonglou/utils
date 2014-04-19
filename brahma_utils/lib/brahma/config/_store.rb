module Brahma::Config
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
      data = data.inject({}) do |h, (k, v)|
        h[k.to_s]= v.kind_of?(Hash) ? v.inject({}) { |h1, (k1, v1)| h1[k1.to_s]=v1; h1 } : v
        h
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
end