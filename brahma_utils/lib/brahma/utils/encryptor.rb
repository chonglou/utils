require 'openssl'
require_relative 'string_helper'

module Brahma
  class Encryptor
    CIPHER = -> { OpenSSL::Cipher::AES256.new(:CBC) }

    def self.generate
      c = CIPHER.call
      {key: c.random_key, iv: c.random_iv}
    end

    def initialize(key, iv)
      @key = key
      @iv = iv
    end

    def encrypt(obj)
      c = CIPHER.call
      c.encrypt
      c.key = @key
      c.iv = @iv

      str = c.update(Marshal.dump({salt: StringHelper.rand_s(16), data: obj}))+c.final
      str.unpack('H*')[0]

    end

    def decrypt(encode)
      encode = [encode].pack('H*')
      c = CIPHER.call
      c.decrypt
      c.key = @key
      c.iv = @iv
      Marshal.load(c.update(encode) + c.final).fetch :data
    end

    def password(obj)
      salt = StringHelper.rand_s(16)
      encode=StringHelper.sha512(Marshal.dump({salt: salt, data: obj}))
      "#{salt}#{encode}"
    end

    def password?(obj, encode)
      salt = encode[0..15]
      encode[16..-1] == StringHelper.sha512(Marshal.dump({salt: salt, data: obj}))
    end


  end
end