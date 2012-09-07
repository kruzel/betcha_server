# To change this template, choose Tools | Templates
# and open the template in the editor.

class BetMailerJob
  def initialize(owner,bet,user,prediction, url)
    @owner = owner
    @bet = bet
    @user = user
    @prediction = prediction
    @url = url
  end
  
  def send_invites
    if(@user.email.nil? || @user.email.length>0)
      BetMailer.send_invite(@owner,@user,@bet,@url).deliver
      return
    end
  end
end
