require 'byebug'
require 'facebook/messenger'
include Facebook::Messenger

unless ARGV.size == 4
  STDERR.puts "Usage: #{$0} <app_secret> <access_token> <verify_token> config.ru"
  exit 1
end

Facebook::Messenger.configure do |config|
  config.app_secret = ARGV.shift
  config.access_token = ARGV.shift
  config.verify_token = ARGV.shift
end

Facebook::Messenger::Subscriptions.subscribe

Bot.on :message do |message|
  #message.id          # => 'mid.1457764197618:41d102a3e1ae206a38'
  #message.sender      # => { 'id' => '1008372609250235' }
  #message.seq         # => 73
  #message.sent_at     # => 2016-04-22 21:30:36 +0200
  #message.text        # => 'Hello, bot!'
  #message.attachments # => [ { 'type' => 'image', 'payload' => { 'url' => 'https://www.example.com/1.jpg' } } ]

  Bot.deliver(
    recipient: message.sender,
    message: {
      text: 'Hello, human!'
    }
  )
end
