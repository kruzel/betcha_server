# To change this template, choose Tools | Templates
# and open the template in the editor.

class BetMailerJob
  def initialize(owner,bet,user,prediction)
    @owner = owner
    @bet = bet
    @user = user
    @prediction = prediction
  end
  
  def send_invites
    BetMailer.send_invite(@owner,@user,@bet,@prediction).deliver
  end
end
