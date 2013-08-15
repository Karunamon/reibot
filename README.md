RBReibot - An IRC bot for roleplay channels and more
====================================================

RBReibot is a continuation of Reibot, an IRC bot project which was originally written in mIRC Scripting Language.

Why Ruby?
---------

* mIRC's scripting syntax is very capable, but it is terribly verbose and is completely procedural.
  
 * Moving to Ruby allows us to redesign the system to be 100% object oriented, and gives us access to some very cool constructs for database work (such as ActiveRecord, used heavily in the Rails ecosystem).



* mIRC has nothing resembling an IDE, all work is done essentially inside a dumb text editor, with a third party DLL loaded for syntax editing. Not terribly fun.

 * RubyMine? NetBeans? Pick your favorite :)



* mIRC's stability isn't great. On a virtual machine dedicated to running the program, it would reliably crash given about a week.

  * Migrating to Ruby makes the bot truly cross-platform, also allowing us to migrate to Linux at the same time.


Current Features
----------------

* Note System

The note system allows you to leave notes for users who are not active or even offline. The next time a user joins the bot's channel (or speaks, if they never left), the bot will deliver all messages a person has waiting for them. This is a godsend on busy channels :)


    <You> ?note TomFubar Hey remember to check the status of the Gonkulator when you get back, thanks!
    <ReiBot> Got it! Note stored for TomFubar.
    ** TomFubar has joined #test
    <ReiBot> TomFubar, you have messages waiting!
    <ReiBot> You, 2012-10-22 07:00:00 MST> Hey remember to check the status of the Gonkulator when you get back, thanks!


* Definitions System

The definitions system allows you to store and retrieve data to arbitrary entries. In Reibot's home server, this functionality is used to store character profiles for role playing purposes. Any information can be stored though - think of anything you need to display repetitively, such as channel rules, or the address for your clan's TF2 server, or a particularly funny quote that someone has inadvertently made...

    <you> ?learn Rules Don't whizz on the electric fence!
    <ReiBot> Got it! I'll remember that info about Rules.
    ** Newbie has joined #test
    <you> Hi Newbie, make sure you read the server rules!
    <newbie> ?? rules
    <ReiBot> [Rules] Don't whizz on the electric fence!

Planned Features
-----------------
* Public Channel Commands

The commands system will allow you to have public commands used for managing your channel. Many IRC servers have services packages loaded which provide this functionality for you - but if your favorite server doesn't use services, or if you'd rather not use them, ReiBot will provide channel management functions on parity with Anope services.

    <you> ?topic Welcome to #test - If this were a real channel, more information would be provided here.
    ** ReiBot has changed topic for #test to: Welcome to #test - If this were a real channel, more information would be provided here.
    <lamer> lol d00d u are t3h sux0r
    <you> ?kb lamer Go be dumb somewhere else
    ** ReiBot has kicked lamer from the channel (Go be dumb somewhere else)

An authentication system will be provided to make sure random skiddies from abusing the bot's managment functions.

What else? The sky is the limit :)

Minimum Requirements
------------

* Ruby 1.9.2 (due to regex handling)
* Bundler (which will handle everything else)

If you don't have bundler, just do a `gem install bundler`. You want to keep this around, as the requirements
for the bot will definitely change over time. Once that's done  `cd` into the bot's folder, and issue a

`bundle install`

.. and all dependencies will be automatically pulled in for you.

Getting Started
---------------

* Edit `rbreibot.yml` to change the bot's name, channels to join, etc. Note that this is a YAML formatted file, whitespace matters! If you get a startup error, try pasting the entire contents of the file into something like https://yaml-online-parser.appspot.com/ to see if the file reads.

If you can't figure it out still, open an issue here and we'll get you sorted out.

* Run `rake db:migrate` to generate the initial database

* Run `main.rb` to start! ReiBot should join the channel you specified and become available for use.


Plugins
-------

TODO


License
-------

The MIT License (MIT)

Copyright (c) 2013 Michael Parks, TKWare Enterprises Ltd.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
