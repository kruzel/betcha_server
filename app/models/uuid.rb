# To change this template, choose Tools | Templates
# and open the template in the editor.

module Uuid
  
    def gen_uid
      if self.id.nil?
        self.id = SecureRandom.uuid
      end
    end
end
