FBBot - the Ruby Hack Night Facebook Bot
========================================

Slides and assets for the FBBot workshop [first presented at Toronto Ruby Hack Night, June 30, 2016]  
Workshop for learning Chatbots, Facebook messaging and Wit.ai
Created by David Andrews and Jason Schweier  

There are no slides for this workshop. All of the materials are contained in this readme.
Here is what we're going to build:
(Facebook Bot design)[https://raw.githubusercontent.com/k00ka/fbbot/master/design.png]

###Introduction
This project is a simple Ruby project. The workshop comes in four parts:
1. create a Facebook app and host it on a page
1. create a Wit.ai bot
1. connect Facebook and Wit.ai
1. customize your bot for a particular purpose

###Setup

Here are the steps to get you started with the repo.

1. For this workshop, you will need a laptop with the following:
  - [x] Ruby 2.x  
  - [x] A Github account  

  Note: We have included a ``.ruby-version`` file locked to 2.2.3, which you can change to any Ruby 2.x version if you don't have 2.2.3 installed  
  More detailed instructions for each platform are included in the footer. Refer there if you are having issues.

1. Fork the repo (optional, recommended):
  From the page https://github.com/k00ka/fbbot, click the Fork button in the top-right corner. Copy the new repo address (in a box just below the thick red line) into your clipboard. Detailed instructions on forking a repo can be found here: https://help.github.com/articles/fork-a-repo/

1. At Ryatta Group we use rbenv, and so we've included some optional elements - just skip them if you're using rvm or are not versioning your Ruby. If you forked the repo above, your repo_address will be in your clipboard. If not, you should use my repo_address ``git@github.com:k00ka/fbbot.git``

  ```sh
  % git clone <paste repo_address>
  % cd fbbot
  % gem install bundler
  Fetching: bundler-1.7.4.gem (100%)
  Successfully installed bundler-1.7.4
  1 gem installed
  % bundle
  Fetching gem metadata from https://rubygems.org/.........
  Resolving dependencies...
  Installing rake 10.3.2
  ...
  Using bundler 1.7.4
  Your bundle is complete!
  Use `bundle show [gemname]` to see where a bundled gem is installed.
  ```
  Note: if you use rbenv...
  ```sh
  % rbenv rehash
  ```
  You are (almost) there!

## How to set up a conversation with your own Facebook bot

1. Do the above
1. Create an ngrok account - http://ngrok.com
1. Download and install ngrok
1. Start ngrok
1. Sign into Facebook
1. Create a page - community - use your name and check “add to favorites”
1. Go here https://developers.facebook.com/quickstarts/?platform=web
1. Create a new app (I called mine k00kabot)
1. Paste your ngrok URL into Site URL (check this)
1. In your project space (shell) type: rackup -p 3000 (don’t hit return)
1. Back in the browser go to your app using top-right menu
1. Click dashboard
1. Click Show beside App Secret
1. Copy the app secret token to the end of your command line
1. Add Messenger on the left menu
1. Choose your new page from the page dropdown
1. Accept the warnings
1. Copy the page access to the end of your command line
1. Click setup web hooks
1. Copy ngrok HTTPS token into the callback URL
1. Set your verify token to something you’ll remember
1. Add the verify token to the end of your command line
1. Click at least the “messages” checkbox
1. Add the text “config.ru” to the end of your command line
1. Hit enter on your command line to run the bot (WEBrick starts)
1. Click verify and save on the application page (should verify)
1. Surf back to your new page
1. Click the “. . .” in the header and choose “View as page visitor”
1. Click “Message” in the header
1. Send a message - you should see “Hello, human”
1. Type ctrl-c to stop your script (don’t kill ngrok!)
1. Echo your command line into the file run1.sh (note: it’s in .gitignore, so you can't check it in with your private deets)
1. Chmod +x run1.sh
1. CELEBRATE BRIEFLY - you have integrated with Facebook successfully - you're 1/3 of the way there

## How to integrate with Wit.ai
1. Create an account on wit.ai
1. In your Wit.ai app, click settings
1. Click the "spinny" icon beside Client Access Token to create one
1. Copy the access to token
1. Paste the access token into the command-line you created earlier (before config1.ru)
1. Change config1.ru to config2.ru and "echo" the resulting command line to run2.sh
1. Chmod +x run2.sh
1. In Wit.ai add a story to your app
1. Create a User Says node, and type "tell me a joke about technology"
1. Highlight "technology" and click "add a new entity"
1. Type "category" and make sure the value says "technology", hit enter
1. Create a Bot Executes node and type "merge"
1. Create a Bot Executes node and type "fetch_joke"
1. Create a Bot Says node and type "{response}"
1. Create a Bot Executes node and type "clear_context"
1. This above node is the main story, providing a joke to the user
1. Click Understanding
1. Think of many different ways of asking for a joke, like: "I like jokes about cars"
1. For each ensure the category, if any, is highlight and correctly identified. Fix it if not.
1. After creating 4 or more examples (some may not include the category), click Stories
1. Continue with a new User Says node, typ4e "What are the categories of jokes?"
1. Highlight the phrase "categories of jokes" phrase and click "add a new entity"
1. Name the entity "meta" and ensure it has the value "categories of jokes"
1. Create a Bot Executes node and type "fetch_categories"
1. Create a Bot Says node and type "{response}"
1. Create a Bot Executes node and type "clear_context"
1. Click "understanding"
1. Click on meta in the lower list and remove "trait"
1. Click "understanding" to go back
1. This of many differetnt ways of asking for categories
1. For each, ensure the query is interpreted correctly (i.e. meta is assigned "categories of jokes")
1. Extend your story with a new User Says node
1. Type the phrase "That was funny"
1. Click "add a new entity" and name it "Sentiment", set the value to "positive"
1. Add a Bot Executes node and type "merge"
1. In "updates context keys with" put "sentiment"
1. Add a Bot Says node and type "Glad you liked it"
1. Add another User Says node
1. Type the text "That's stupid"
1. Click "add a new entity" and name it "Sentiment", set the value to "negative"
1. Add a Bot Executes node to run the "merge" function
1. In "updates context keys with" put "sentiment"
1. Add a Bot Says node and type "There's no pleasing some people."
1. Click "understanding" and train up these two interactions - ensuring each has either positive or negative values for sentiment
1. Run your bot by typiing "./run2.sh" at the command-line
1. Go into your Facebook chat and give it a try!
1. Play, train and revise

## Congratulations, you've created a Facebook bot with Natural Language Parsing and Artificial Intelligance!
