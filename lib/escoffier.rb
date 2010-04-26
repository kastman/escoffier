$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'escoffier/core_additions'
require 'escoffier/normalizer'
require 'escoffier/compressible'
require 'escoffier/sandboxable'

module Escoffier
  VERSION = '0.0.1'
end