$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'rubygems'
require 'spec'
require 'escoffier'


describe "Normalize Compression" do  
  
  before(:all) do
    options = Hash.new
    options[:dry_run] = true
    @normalizer = Normalizer.new('/tmp/awr011_8414_06182009', options)
  end

  it "should normalize compression" do
    @normalizer.normalize_directory!
  end
  
  # after(:each) do
  # end
  
end