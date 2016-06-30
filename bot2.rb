require 'byebug'
require 'facebook/messenger'
include Facebook::Messenger
require 'bundler/setup' # supports running the wit gem directly from github
require 'wit'

unless ARGV.size == 5
  STDERR.puts "Usage: #{$0} <fb_app_secret> <fb_access_token> <fb_verify_token> <wit_access_token> <rackup_config>"
  exit 1
end

$contexts = Hash.new({})

Bot.on :message do |message|
  session_id = message.sender['id'] # use the FB sender ID as the Wit session
  $wit.run_actions(session_id, message.text, $contexts[session_id])
end

def say(session_id, context, message)
  $contexts[session_id] = context
  STDERR.puts "Sending Wit response '#{message}' to '#{session_id}' in Facebook"
  Bot.deliver(recipient: { id: session_id }, message: { text: message })
end

def error(session_id, context, error)
  $contexts[session_id] = context
  STDERR.puts "Sending Wit error '#{error.message}' back to Facebook"
  Bot.deliver(recipient: { id: session_id }, message: { text: error.message })
end

# default approach: accumulate everything, ignoring confidence
def merge(session_id, context, entities, msg)
  entities.each_pair { |k,v| context[k.to_s] = v.first["value"] }
  STDERR.puts "Merged Wit entities '#{entities}' into context '#{context}'"
  # This is one way to handle derived context
  case context["sentiment"]
  when 'positive'
    context["ack"] = 'Glad you liked it!'
  when 'negative'
    context["ack"] = 'Hmm.'
  else
    # sentiment not set (yet)
  end
  $contexts[session_id] = context
end

def clear_context(session_id, context)
end

$JOKES = {
  "chuck" => [
    'Chuck Norris counted to infinity - twice.',
    'Death once had a near-Chuck Norris experience.'
  ],
  "tech" => [
    'Did you hear about the two antennas that got married? The ceremony was long and boring, but the reception was great!',
    'Why do geeks mistake Halloween and Christmas? Because oct(31) == dec(25).'
  ],
  "default" => [
    'Why was the Math book sad? Because it had so many problems.'
  ],
}

def fetch_joke(session_id, context)
  $contexts[session_id] = context
  category = context["category"] || "default"
  STDERR.puts "Finding a joke with Wit context '#{context}'"
  $contexts[session_id]["joke"] = $JOKES[category].sample
  $contexts[session_id]
end

# setup up FB connection
Facebook::Messenger.configure do |config|
  config.app_secret = ARGV.shift
  config.access_token = ARGV.shift
  config.verify_token = ARGV.shift
end
Facebook::Messenger::Subscriptions.subscribe

# setup Wit connection
$actions = {
  say: method(:say),
  error: method(:error),
  merge: method(:merge),
  fetch_joke: method(:fetch_joke),
  clear_context: method(:clear_context)
}
$wit = Wit.new(ARGV.shift, $actions, Logger.new(STDERR))
