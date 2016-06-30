FBBot - the Ruby Hack Night Facebook Bot
========================================

Slides and assets for the FBBot workshop [first presented at Toronto Ruby Hack Night, June 30, 2016]  
Workshop for learning Chatbots, Facebook messaging and Wit.ai
Created by David Andrews and Jason Schweier  

Slides for the workshop are here: _FYI remarkise doesn't work in Safari, sorry_  
https://gnab.github.io/remark/remarkise?url=https://raw.githubusercontent.com/k00ka/fbbot/master/SLIDES.md

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

## How to set up a conversation with your own Faecbook bot

1. join Github
2. surf to github.com/k00ka/fbbot
2. fork the app - https://github.com/hyperoslo/facebook-messenger
3. clone it
4. install the bundle
5. create an grok account
6. download and install ngrok
7. start ngrok
8. sign into Facebook
9. create a page - community - use your name and check “add to favourites”
10. go here https://developers.facebook.com/quickstarts/?platform=web
11. create a new app (I called my k00kabot)
12. paste your ngrok URL into Site URL (check this)
13. in your project space (shell) type: rackup -p 3000 (don’t hit return)
13. back in the browser go to your app using top-right menu
14. click dashboard
15. click Show beside App Secret
16. copy the app secret token to the end of your command line
17. add Messenger on the left menu
18. choose your new page from the page dropdown
19. accept the warnings
20. copy the page access to the end of your command line
21. click setup web hooks
22. copy ngrok HTTPS token into the callback URL
23. set your verify token to something you’ll remember
24. add the verify token to the end of your command line
25. click at least the “messages” checkbox
26. add the text “config.ru” to the end of your command line
27. hit enter on your command line to run the bot (WEBrick starts)
28. click verify and save on the application page (should verify)
29. surf back to your new page
30. click the “. . .” in the header and choose “View as page visitor”
31. click “Message” in the header
32. send a message - you should see “Hello, human”
33. type ctrl-c to stop your script (don’t kill ngrok!)
34. echo your command line into the file run1.sh (note: it’s in .gitignore, so you can't check it in with your private deets)
35. chmod +x run1.sh
36. CELEBRATE BRIEFLY - you have integrated with Facebook successfully - you're 1/3 of the way there

37. create a new account on wit.ai -just use your Github account
38. once logged in, create a new app using the + button in the header
39. name your app "jokeapp"
40. create a new story called "tell me a joke"
41. start with a "user says" node, type "tell me a joke about technology"
42. 

## Congrats on your new Facebook bot!
