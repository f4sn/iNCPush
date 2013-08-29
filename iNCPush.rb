# encoding: utf-8
require './setting'
require 'digest/sha1'
require 'net/http'
require 'json'
require 'tweetstream'
require 'twitter'
require 'pp'

module IM
 class Kayac
   HOST = 'im.kayac.com'
   def initialize(to, params={})
     if to.nil?
       raise ArgumentError
     else
       @to = to
     end
     @id  = params[:id]
     @pwd = params[:password]
     @sig = params[:sig]
   end

   def notify(msg,han)
     if !@sig.nil?
       sig = Digest::SHA1.hexdigest(msg + @sig)
       data = 'message=%s&amp;handler=%s;sig=%s' % [u(msg),u(han),sig]
     elsif !@pwd.nil?
       data = 'message=%s&amp;password=%s;handler=%s' % [u(msg), u(@pwd),u(han)]
     else
       data = 'message=%s;handler=%s' % [u(msg),u(han)]
     end
     data << '&amp;id=%s' % [u(@id)] unless @id.nil?
     header = {
       'Host' => HOST,
       'Content-Type' => 'application/x-www-form-urlencoded',
       'Content-length' => data.size.to_s,
     }

     path = '/api/post/%s' % [@to]
     Net::HTTP.version_1_2
     Net::HTTP.start(HOST, 80) do |http|
       http.post(path, data, header)
     end
   end
   
   private
   def u(str)
      str.to_s do
       '%%%02X' % $&.unpack("C").first
     end
   end

 end
end


iNC = IM::Kayac.new(TO_ID,:Id=>MY_ID, :password =>PAS,:sig=>SIG)

#Ck/Cs
  Twitter.configure do |config|
  config.consumer_key       = CONSUMER_KEY
  config.consumer_secret    = CONSUMER_SECRET
  config.oauth_token        = OAUTH_TOKEN
  config.oauth_token_secret = OAUTH_SECRET
end

  TweetStream.configure do |config|
  config.consumer_key       = CONSUMER_KEY
  config.consumer_secret    = CONSUMER_SECRET
  config.oauth_token        = OAUTH_TOKEN
  config.oauth_token_secret = OAUTH_SECRET
  config.auth_method        = :oauth
end


client = TweetStream::Client.new
puts "OK"

  client.on_error do |message|
end

  client.on_direct_message do |direct_message|
end

  client.on_delete do |del|
end

client.on_timeline_status  do |status|

  mes_sn=status.user.screen_name
  mes_n=status.user.name
  mes_t=status.text
  iNC.notify(mes_sn+"\n"+mes_n+"\n"+mes_t,nil)
  
end

client.userstream
