require 'fileutils'
require 'pathname'
require 'tmpdir'
require 'logger'
require 'escoffier/compressible'

# Standard Mise en Place-able
module Smepable
  $LOG ||= Logger.new(STDOUT)
  include Compressible
  
  def prep_mise(input_entry, output_directory = Dir.mktmpdir)
    # destination_dirname = File.dirname(output_directory)
    FileUtils.mkdir_p(output_directory) unless File.exist?(output_directory)
    $LOG.info "Copying #{input_entry} to #{output_directory}"
    verbose = $LOG.level <= Logger::DEBUG
    source = input_entry
    FileUtils.cp_r(source, output_directory, :verbose => verbose)
    $LOG.info "Unzipping #{output_directory}"
    unzip(output_directory, :recursive => true)
    
    return output_directory
  end
  
end
