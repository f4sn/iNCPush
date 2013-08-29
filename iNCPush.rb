# encoding: utf-8
require 'digest/sha1'
require 'net/http'
require 'json'
require 'tweetstream'
require 'twitter'
require 'pp'
require './kayac_module.rb'
class Hoge
  include IM
end
require 'setting'
iNC = IM::Kayac.new(to_id,:id=>my_id, :password =>pas,:sig=>sig)

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
