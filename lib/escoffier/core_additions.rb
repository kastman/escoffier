require 'escoffier/smepable'

class Pathname
  include Smepable
  
  def prep_mise_to(output_dir)
    self.prep_mise(self.to_s, output_dir)
  end
end