module Compressible
  # Unzips a file on the filesystem using the bzip2 algorithm.
  # Pass in a path to a file, and optional options.
  #
  # options:
  # :output_path => 'path' Where the file should go if not the same directory as the zipped file.
  # :remove_original => [true] Specify if the original zipped file should be 
  # removed after unzipping.
  # :recursive => [true]
  def unzip(entry, options = Hash.new)
    
    if options[:recursive]
      Find.find(entry) do |entry|
        next unless File.exists?(entry)
        next if File.directory?(entry)
        next unless entry =~ /.bz2$/
        
        unzip_entry(entry, options)
      end
    else
      unzip_entry(entry, options)
    end
    
  end
  
  # Zips a file on the filesystem using the bzip2 algorithm.
  # Pass in a path to a file, and optional options.
  # options:
  # :output_path => Where the file should go if not the same directory as the unzipped file.
  # :remove_original => [true] Specify if the original zipped file should be 
  # removed after unzipping.
  def zip(file, options = Hash.new)
    if options[:output_path]
      output_path = options[:output_path]
    else 
      output_path = File.dirname(File.expand_path(file))
    end
    
    options[:remove_original] = true if options[:remove_original].nil?
    
    decompressed_filename = File.expand_path(file)
    compressed_filename = File.join(output_path, File.basename(file) + '.bz2')
    puts "Compressing #{decompressed_filename} to #{compressed_filename}"
    Bzip2::Writer.open(compressed_filename, 'w') do |compressed_file|
      File.open(decompressed_filename, 'r') do |decompressed_file|
        compressed_file << decompressed_file.read
      end
    end

    if File.exist?(compressed_filename)
      File.delete(decompressed_filename) if options[:remove_original]
    end
    
    return compressed_filename
  end
  
  private
  
  def unzip_entry(file, options = Hash.new)
    if options[:output_path]
      output_path = options[:output_path]
    else 
      output_path = File.dirname(File.expand_path(file))
    end
    
    options[:remove_original] = true if options[:remove_original].nil?
    
    compressed_filename = File.expand_path(file)
    decompressed_filename = File.join(output_path, File.basename(file, '.bz2'))
    $LOG.debug "Decompressing #{compressed_filename} to #{decompressed_filename}"

    begin
      # raise NoMemoryError

      Bzip2::Reader.open(compressed_filename, 'r') do |compressed_file|
        begin
          File.open(decompressed_filename, 'w') do |decompressed_file| 
              decompressed_file << compressed_file.read
          end
        rescue Bzip2::EOZError => e
          raise(Bzip2::EOZError, "Problem decompressing #{compressed_filename}")
        end
      end

      if File.exist?(decompressed_filename)
        File.delete(compressed_filename) if options[:remove_original]
      end
    # Currently the Bzip2 library has a problem with very large files.
    rescue NoMemoryError => e
      # raise e
      File.delete(decompressed_filename) if File.exists?(decompressed_filename)
      cmd = "bunzip2 #{compressed_filename} #{decompressed_filename}"
      puts cmd
      system(cmd)
    end
    
    
    return decompressed_filename 
  end
end