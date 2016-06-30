# config.ru
require 'facebook/messenger'
require_relative 'bot2'

run Facebook::Messenger::Server
