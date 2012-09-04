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
    #if user have an installed app, send to app through push notifications
#    user = FbGraph::User.new('750750911')
#    user.notification!(
#      :access_token => 'BAAEQVW8sX2cBAPwueSXPYGyvS3JABV4CU0OMebYFUydfYtgaNOWQ9lCm3urBZChgZAbcXutncRO7goPp3It597RHRNCKNQc524ZCoPRZBCWhQa36eRWBGtNN1NgHw9YZD',
#      :href => 'http://www.dropabet.com',
#      :template => 'Join my bet'
#    )
        
    #if user have email send through email (in addition to push)
    BetMailer.send_invite(@owner,@user,@bet,@prediction).deliver
    
    #if no email and have FB, send through FB (in addition to push)
    
  end
end
