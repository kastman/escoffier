#!/usr/bin/env ruby
$:.unshift File.join(File.dirname(__FILE__),'..','lib')

# require 'rubygems'
require 'optparse'
require 'etc'
require 'logger'
require 'yaml'
require 'escoffier'


  
def parse_options
  options = Hash.new
  parser = OptionParser.new do |opts|
    opts.banner = "Usage: normalize_directory.rb [options] list of directories."

    # opts.on('-d', '--directory DIR', "Directory to Normalize")     do |dir| 
    #   abort 
    #   options[:directory] = dir
    # end

    opts.on('-u', '--user USER', "The user who should own the files.")   do |user| 
      abort "Cannot find user #{user}." unless Etc.getpwnam(user)
      options[:user] = user
    end
    
    opts.on('-g', '--group GROUP', "The group who should own the files.") do |group|
      abort "Cannot find group #{group}." unless Etc.getgrnam(group)
      options[:group] = group
    end
    
    opts.on('-s', '--spec FILE', "A configuration file of directories.") do |file|
      options[:specfile] = file
    end

    opts.on('--dry-run', "Display Ownership Changes but don't make them.") do
      options[:dry_run] = true
    end

    opts.on_tail('-h', '--help',          "Show this message")          { puts(parser); exit }
    opts.on_tail("Example: normalize_directory.rb -u raw -g raw /Data/vtrak1/raw")
  end
  parser.parse!(ARGV)
  return options
end

def normalize!(options)
  directories = ARGV.to_a
  directories.each do |directory|
    unless File.directory?(directory)
      puts "Error: Cannot find directory #{dir}."
      next
    end
    normalizer = Normalizer.new(directory, options)
    normalizer.normalize_directory!
  end
end

if File.basename(__FILE__) == File.basename($PROGRAM_NAME)
  $LOG = Logger.new(STDOUT)
  
  options = parse_options
  if options[:spec]
    directories = 
  end
  normalize!(options)
end