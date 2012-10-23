RBReibot - An IRC bot for roleplay channels and more
====================================================

RBReibot is a continuation of Reibot, an IRC bot project which was originally written in mIRC Scripting Language.

Why Ruby?
=========
* mIRC's scripting syntax is very capable, but it is terribly verbose and is completely procedural. Moving to Ruby allows us to redesign the system to be 100% object oriented, and gives us access to some very cool constructs for database work (such as ActiveRecord, used heavily in the Rails ecosystem). mIRC has nothing resembling an IDE, all work is done essentially inside a dumb text editor, with a third party IDE laoded for syntax editing. Not terribly fun.

* mIRC's stability isn't great. On a virtual machine dedicated to running the program, it would reliably crash given about a week. Migrating to Ruby makes the bot truly cross-platform, also allowing us to migrate to Linux at the same time.


Features
========

* Note System (in development)

The note system allows you to leave notes for users who are not active or even offline. The next time a user joins the bot's channel (or speaks, if they never left), the bot will deliver all messages a person has waiting for them. This is a godsend on busy channels :)


    <You> ?note TomFubar Hey remember to check the status of the Gonkulator when you get back, thanks!
    <ReiBot> Got it! Note stored for TomFubar.
    ** TomFubar has joined #test
    <ReiBot> TomFubar, you have messages waiting!
    <ReiBot> You, 2012-10-22 07:00:00 MST> Hey remember to check the status of the Gonkulator when you get back, thanks!


* Definitions System (in development)

The definitions system allows you to store and retrieve data to arbitrary entries. In Reibot's home server, this functionality is used to store character profiles for role playing purposes. Any information can be stored though - think of anything you need to display repetitively, such as channel rules, or the address for your clan's TF2 server, or a particularly funny quote that someone has inadvertently made...

   <you> ?learn Rules Don't whizz on the electric fence!
   <ReiBot> Got it! I'll remember that info about Rules.
   ** Newbie has joined #test
   <you> Hi Newbie, make sure you read the server rules!
   <newbie> ?? rules
   <ReiBot> [Rules] Don't whizz on the electric fence!

* Public Channel Commands (in development)

The commands system allows you to have public commands used for managing your channel. Many IRC servers have services packages loaded which provide this functionality for you - but if your favorite server doesn't use services, or if you'd rather not use them, ReiBot will provide channel management functions on parity with Anope services.

   <you> ?topic Welcome to #test - If this were a real channel, more information would be provided here.
   ** ReiBot has changed topic for #test to: Welcome to #test - If this were a real channel, more information would be provided here.
   <lamer> lol d00d u are t3h sux0r
   <you> ?kb lamer Go be dumb somewhere else
   ** ReiBot has kicked lamer from the channel (Go be dumb somewhere else)

An authentication system will be provided to make sure random skiddies from abusing the bot's managment functions.

What else? The sky is the limit :)

Requirements
============

* Ruby 1.9.2
* ActiveRecord
* Cinch
* sqlite3

Those final three are just ruby gems. If your system is set up sanely, you can do:

   $gem install activerecord cinch sqlite3

Getting Started
===============

* Edit rbreibot.yml to change the bot's name, channels to join, etc. Note that this is a YAML formatted file, whitespace matters! If you get a startup error, try pasting the entire contents of the file into something like https://yaml-online-parser.appspot.com/ to see if the file reads.

If you can't figure it out still, open an issue here and we'll get you sorted out.

* Run main.rb to start! ReiBot should join the channel you specified and become available for use.


Plugins
=======

Plugin documentation will be here later :)


License
=======
* Commercial use: Ask first. I don't want money for this, but I am quite curious as to where Reibot is popping up, if anywhere. You're not allowed to use Reibot for commercial purposes without at least doing this one small thing. Commercial use I define as operating on a server owned or operated by a company you own or work for, or a subsidary of any company you own or work for.

* Personal use: Creative Commons BY-NC-SA