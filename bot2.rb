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
  STDERR.puts "Got '#{message}' from '#{session_id}' on Facebook. Forwarding to Wit"
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
  unless entities.nil?
    entities.each_pair { |k,v| context[k.to_s] = v.first["value"] }
    STDERR.puts "Merged Wit entities '#{entities}' into context '#{context}'"
  end
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
  $contexts[session_id] = {}
end

$JOKES = {
"logic" => [
  "There are only 10 types of people in the world: those that understand binary and those that don’t.",
  "Computers make very fast, very accurate mistakes.",
  "Be nice to the nerds, for all you know they might be the next Bill Gates!",
  "Artificial intelligence usually beats real stupidity.",
  "To err is human – and to blame it on a computer is even more so.",
  "CAPS LOCK – Preventing Login Since 1980." ],

"the web" => [
  "The truth is out there. Anybody got the URL?",
  "The Internet: where men are men, women are men, and children are FBI agents.",
  "Some things Man was never meant to know. For everything else, there’s Google." ],

"operating systems" => [
  "The box said ‘Requires Windows Vista or better’. So I installed LINUX.",
  "UNIX is basically a simple operating system, but you have to be a genius to understand the simplicity.",
  "In a world without fences and walls, who needs Gates and Windows?",
  "C://dos, C://dos.run, run.dos.run",
  "Bugs come in through open Windows.",
  "Penguins love cold, they wont survive the sun.",
  "Unix is user friendly. It’s just selective about who its friends are.",
  "Failure is not an option. It comes bundled with your Microsoft product.",
  "NT is the only OS that has caused me to beat a piece of hardware to death with my bare hands.",
  "My daily Unix command list: unzip; strip; touch; finger; mount; fsck; more; yes; unmount; sleep.",
  "Microsoft: “You’ve got questions. We’ve got dancing paperclips.”",
  "Erik Naggum: “Microsoft is not the answer. Microsoft is the question. NO is the answer.”",
  "Windows isn’t a virus, viruses do something.",
  "Computers are like air conditioners: they stop working when you open Windows.",
  "Mac users swear by their Mac, PC users swear at their PC." ],
 
"development" => [
  "If at first you don’t succeed; call it version 1.0.",
  "My software never has bugs. It just develops random features.",
  "I would love to change the world, but they won’t give me the source code.",
  "The code that is the hardest to debug is the code that you know cannot possibly be wrong.",
  "Beware of programmers that carry screwdrivers.",
  "Programming today is a race between software engineers striving to build bigger and better idiot-proof programs, and the Universe trying to produce bigger and better idiots. So far, the Universe is winning.",
  "The beginning of the programmer’s wisdom is understanding the difference between getting program to run and having a runnable program.",
  "I’m not anti-social; I’m just not user friendly.",
  "Hey! It compiles! Ship it!",
  "If Ruby is not and Perl is the answer, you don’t understand the question.",
  "The more I C, the less I see.",
  "COBOL programmers understand why women hate periods.",
  "Michael Sinz: “Programming is like sex, one mistake and you have to support it for the rest of your life.”",
  "If you give someone a program, you will frustrate them for a day; if you teach them how to program, you will frustrate them for a lifetime.",
  "Programmers are tools for converting caffeine into code.",
  "My attitude isn’t bad. It’s in beta.",
  "Get the Beta joke on a T-Shirt from the MakeUseOf T-Shirt store." ],

"computations" => [
  "There are three kinds of people: those who can count and those who can’t.",
  "Latest survey shows that 3 out of 4 people make up 75% of the world’s population.",
  "Hand over the calculator, friends don’t let friends derive drunk.",
  "An infinite crowd of mathematicians enters a bar. The first one orders a pint, the second one a half pint, the third one a quarter pint… “I understand”, says the bartender – and pours two pints.",
  "1f u c4n r34d th1s u r34lly n33d t0 g37 l41d." ],

"computing" => [
  "Enter any 11-digit prime number to continue.",
  "E-mail returned to sender, insufficient voltage.",
  "All wiyht. Rho sritched mg kegtops awound?",
  "Black holes are where God divided by zero.",
  "If I wanted a warm fuzzy feeling, I’d antialias my graphics!",
  "If brute force doesn’t solve your problems, then you aren’t using enough.",
  "SUPERCOMPUTER: what it sounded like before you bought it.",
  "Evolution is God’s way of issuing upgrades.",
  "Linus Torvalds: “Real men don’t use backups, they post their stuff on a public ftp server and let the rest of the world make copies.”",
  "Hacking is like sex. You get in, you get out, and hope that you didn’t leave something that can be traced back to you." ]
}

def fetch_joke(session_id, context)
  $contexts[session_id] = context
  category = (context["category"] || $JOKES.keys.last).downcase
  return fetch_categories(session_id, context) unless $JOKES.keys.include? category
  STDERR.puts "Finding a joke with Wit context '#{context}'"
  $contexts[session_id]["response"] = $JOKES[category].sample
  $contexts[session_id]
end

def fetch_categories(session_id, context)
  $contexts[session_id] = context
  categories = $JOKES.keys.join(', ')
  STDERR.puts "Returning the list of joke categories: #{categories}"
  $contexts[session_id]["response"] = "I know jokes in the following categories: #{categories}"
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
  clear_context: method(:clear_context),
  fetch_joke: method(:fetch_joke),
  fetch_categories: method(:fetch_categories)
}
$wit = Wit.new(ARGV.shift, $actions, Logger.new(STDERR))
