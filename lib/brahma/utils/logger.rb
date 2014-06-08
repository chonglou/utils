require 'singleton'
require 'fileutils'
require 'logger'

module Brahma
  module Utils
    class Syslog
      def initialize(name)
        require 'syslog/logger'
        @logger = ::Syslog::Logger.new 'brahma'
        @name = name
      end

      def info(message)
        log message, :info
      end

      def error(message)
        log message, :error
      end

      def debug(message)
        log message, :debug
      end

      private
      def log(message, flag)
        @logger.send flag, "#{@name} - #{message}"
      end
    end

    class Logger
      include Singleton

      def setup(path=nil)
        unless path.nil?
          Dir.exist?(path) || FileUtils.mkdir_p(path)
        end
        @path = path
      end

      def create(name)
        if @path.nil?
          Brahma::Utils::Syslog.new name
        else
          logger = ::Logger.new("#{@path}/#{name}.log", 'daily')
          logger.level = ::Logger::DEBUG
          logger
        end
      end
    end

  end
end