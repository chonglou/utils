require 'securerandom'
require 'digest'
require 'base64'
require 'nokogiri'
require 'redcarpet'

module Brahma::Utils
  module StringHelper
    CHARS=('a'..'z').to_a + ('0'..'9').to_a
    MARKDOWN = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, space_after_headers: true)
    module_function

    def rand_s(len)
      ss = ''
      1.upto(len) { |_| ss<<CHARS[rand(CHARS.size-1)] }
      ss
    end

    def rand_s!(len)
      `pwgen -s #{len} 1`.chomp
    end

    def uuid
      SecureRandom.uuid
    end

    def obj2hex(obj)
      Marshal.dump(obj).unpack('H*')[0]
    end

    def hex2obj(hex)
      Marshal.load [hex].pack('H*')
    end

    def md5(str)
      Digest::MD5.hexdigest str
    end

    def sha512(str)
      Digest::SHA512.hexdigest str
    end

    def md2html(markdown)
      MARKDOWN.render markdown
    end

    def html2text(html)
      Nokogiri::HTML(html).text
    end

  end
end