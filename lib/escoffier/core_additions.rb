require 'escoffier/sandboxable'

class Pathname
  include Sandboxable
  
  def sandbox_to(output_dir)
    self.sandbox(self.to_s, output_dir)
  end
end