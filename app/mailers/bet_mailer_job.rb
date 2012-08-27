# To change this template, choose Tools | Templates
# and open the template in the editor.

class BetMailerJob
  def initialize(bet,user)
    @bet = bet
    @user = user
  end
  
  def send_invites
    BetMailer.send_invite(@user,@bet).deliver
  end
end
