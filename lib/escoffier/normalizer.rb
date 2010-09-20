require 'find'
require 'etc'
require 'bzip2_ext'
require 'escoffier/compressible'

class Normalizer
  COMPRESSION_REGEXES = /\.bz2$/
  PFILE_REGEXES = [/^P\d{5}\.7$/]
  DICOM_REGEXES = [/\d{3,5}.dcm$/, /I?.\d{4}$/ ]
  IMAGE_REGEXES = [PFILE_REGEXES, DICOM_REGEXES].flatten
  
  include Compressible
  attr_reader :entry_path
  
  def initialize(entry_path, options = Hash.new)
    if options[:user]
      user = options[:user]
    else
      user = 'raw'
    end
    
    if options[:group]
      group = options[:group]
    else
      group = 'raw'
    end
    
    if options[:dry_run]
      @dry_run = true
    else
      @dry_run = false
    end
    
    unless Process.uid == 0 || @dry_run
      puts "The normalizer must be run as root for correct permissions. Please use 'sudo'." 
      exit
    end
        
    @entry_path = entry_path
    @uid, @gid, @username, @groupname = Etc.getpwnam(user).uid, Etc.getgrnam(group).gid, user, group
  end
  
  def normalize_directory!
    puts "Scanning #{@entry_path}"
    
    # Toggle Zippedness
    Find.find(@entry_path) do |file|
      next unless File.exists?(file)
      next if File.directory?(file)

      file = normalize_compression(file)
      normalize_ownership(file)

    end
  end
  
  def normalize_compression(file)
     IMAGE_REGEXES.each do |regex|
       if file =~ regex
         file = zip(file) unless @dry_run
       end
     end

    # if file =~ COMPRESSION_REGEXES
    #  unzip(file)
    # end
    
    return file
  end
  
  def normalize_ownership(file, owner = 'raw', maximum_perms = 0755)
    stat = File.stat(file)
    
    file_uid, file_gid, mode = stat.uid, stat.gid, stat.mode
    
    begin
      if file_uid != @uid
        begin
          current_owner = Etc.getpwuid(file_uid).name
        rescue ArgumentError # No such user; just use UID
          current_owner = "uid #{file_uid}"
        end
        puts " CHOWN #{file}"
        puts "  Current owner is #{current_owner}, should be #{@username}"
        File.chown(@uid, nil, file) unless @dry_run
      end
    
      if file_gid != @gid
        begin
          current_group = Etc.getgrgid(file_gid).name
        rescue ArgumentError # No such group; just use GID
          current_group = "gid #{file_gid}"
        end
        puts " CHOWN #{file}"
        puts "  Current group is #{current_group}, should be #{@groupname}"
        File.chown(nil, @gid, file) unless @dry_run
      end
    
      perms = mode & 0777
      should_be = perms & maximum_perms
      if perms != should_be
        puts " CHMOD #{file}"
        puts "  Current perms are #{perms.to_s(8)}, should be #{should_be.to_s(8)}"
        File.chmod(perms & maximum_perms, file) unless @dry_run
      end
    rescue Exception => e
      if e.errno == 'eperm'
        puts "Cannot change ownership - insufficient permissions."
      else
        raise e
      end
    end
  end
end