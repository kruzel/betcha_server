# To change this template, choose Tools | Templates
# and open the template in the editor.

class BetMailerJob
  def initialize(bet,user,prediction)
    @bet = bet
    @user = user
    @prediction = prediction
  end
  
  def send_invites
    BetMailer.send_invite(@user,@bet,@prediction).deliver
  end
end
