# To change this template, choose Tools | Templates
# and open the template in the editor.

class BetMailerJob
  def initialize(user, bet)
    @user = user
    @bet = bet
  end
  
  def send_invite
    BetMailer.send_invite(@user,@bet).deliver
  end
  handle_asynchronously :send_invite
  
end
