require_relative '_store'
require_relative '../utils/string_helper'

module Brahma::Config
  class Keys < Storage

    def load(env)
      if ENVIRONMENTS.include?(env)
        cfg = read.fetch(env)
        {
            key: Brahma::Utils::StringHelper.hex2obj(cfg.fetch('key')),
            iv: Brahma::Utils::StringHelper.hex2obj(cfg.fetch('iv'))
        }
      end
    end

    def setup!
      p_s '更新KEY'
      keys_d = {}
      ENVIRONMENTS.each do |env|
        ks = Brahma::Utils::Encryptor.generate
        keys = {}
        keys['key'] = Brahma::Utils::StringHelper.obj2hex ks.fetch(:key)
        keys['iv'] = Brahma::Utils::StringHelper.obj2hex ks.fetch(:iv)
        keys_d[env] = keys
      end
      p_s '刷新配置文件'
      write keys_d
    end
  end
end