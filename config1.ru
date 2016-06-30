# config.ru
require 'facebook/messenger'
require_relative 'bot1'

run Facebook::Messenger::Server
