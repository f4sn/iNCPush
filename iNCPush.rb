# encoding: utf-8
#!/usr/bin/env ruby
require './setting'
require './im_modul'
require 'digest/sha1'
require 'net/http'
require 'json'
require 'tweetstream'
require 'twitter'
require 'pp'

include IM


iNC = IM::Kayac.new(TO_ID,:Id=>MY_ID, :password =>PAS,:sig=>SIG)

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
puts "Successful connection"

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
  iNC.notify(mes_sn+"\n"+mes_n+"\n"+mes_t,nil) #第2引数にはURLSchemeを指定できます('music:'、'mailto:'、'http://google.com'等)
  puts "name :#{mes_n}/#{mes_sn}\ntext :#{mes_t}\n\n"
  
end

client.userstream
