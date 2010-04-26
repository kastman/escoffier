$:.unshift File.join(File.dirname(__FILE__),'..','lib')

# require 'rubygems'
require 'spec'
require 'fileutils'
require 'logger'
require 'escoffier'
require 'escoffier/smepable'
require 'escoffier/core_additions'


describe "Test Copying and Unzipping with Standard Mise En Place SMEP" do  
  
  before(:all) do
    @test_directories = {
      :small_dataset => {
        :raw => '/Data/vtrak1/raw/carlson.sharp.visit1/shp00005_421_02232010/006', 
        :source => '/tmp/shp00005_006', 
        :destination => '/tmp/shp00005_006_sandbox' 
      }, 
      :full_visit => {
        :raw => '/Data/vtrak1/raw/carlson.sharp.visit1/shp00005_421_02232010/', 
        :source => '/tmp/shp00005', 
        :destination => '/tmp/shp00005_sandbox' 
      }
    }

    @test_directories.each do |label, directory|
      unless File.exists?(directory[:source])
        puts "One-time preparation of Testing Source Directory"
        FileUtils.cp_r(directory[:raw], directory[:source])
      end
      FileUtils.rm_r(directory[:destination]) if File.exists?(directory[:destination])
    end
    
    $LOG = Logger.new(STDOUT)
    
  end

  it "should unzip and decompress a small image dataset inside a sandbox" do
    directory = @test_directories[:small_dataset]
    d = Pathname.new(directory[:source])
    d.prep_mise(directory[:source], directory[:destination])
  end
  
  it "should unzip and decompress a full visit inside a sandbox" do
    directory = @test_directories[:full_visit]
    d = Pathname.new(directory[:source])
    d.prep_mise(directory[:source], directory[:destination])
  end
  
  
  # after(:each) do
  # end
  
end