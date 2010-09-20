$LOAD_PATH.unshift(File.dirname(__FILE__)) unless
  $LOAD_PATH.include?(File.dirname(__FILE__)) || $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))

begin
  require 'bzip2_ext'
rescue LoadError
  require 'rubygems'
  gem 'bzip2-ruby'
  require 'bzip2_ext'
end

require 'escoffier/core_additions'
require 'escoffier/normalizer'
require 'escoffier/compressible'
require 'escoffier/smepable'

module Escoffier
  VERSION = '0.0.1'
end