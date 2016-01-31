RBReibot - An IRC utility bot for gaming channels
=================================================

**DEPRECATED**

RBReibot has been deprecated in favor of AsrielBot. Please see the [AsrielBot](https://github.com/Karunamon/AsrielBot) repository for any future development.

This is continuation of an IRC bot project which was originally written in mIRC Scripting Language. 

Reibot is an all-around utility bot for gaming or roleplay channels. It includes a number of helpful functions such as a dice roller, information retrieval, and so forth.

The backend of the bot uses the [Cinch](https://github.com/cinchrb/cinch) IRC framework - this allows for easy development of functionality without needing to worry about IRC internals. If you have any desire of writing your own bot to do various things, you can't go wrong with Cinch!


Didn't this used to be a mIRC project?
--------------------------------------

Yup! But there are a number of reasons I decided to migrate to Ruby.

mIRC's scripting syntax is very capable, but it is terribly verbose and is completely procedural. Moving to Ruby allows us to redesign the system to be 100% object oriented, and gives us access to a lot of helpful tools. We can use things like ActiveRecord for database objects, Cinch for IRC, and so forth, allowing a level of flexibility that was simply not possible with mIRC.

mIRC had some pain points too, seeing as how it's designed as an IRC client, not a server platform. It had its own (very spartan) code editor, it was a bit on the unstable side, and come to find out about it, their community is somewhat hostile to projects which relegate their software to a platform. The move to Ruby allows Reibot to be truly cross platform, as it can run on anything the Ruby interpreter does. That means Linux, Windows, MacOS, and so on.


Features and usage
------------------

* Note system

The note system allows you to leave notes for users who are not active or even offline. The next time a user joins the bot's channel (or speaks, if they never left), the bot will deliver all messages a person has waiting for them. This is super helpful on busy channels, and unlike the MemoServ system provided by most IRC service packages, you can leave notes for people who are not registered.

    <You> ?note TomFubar Hey remember to check the status of the Gonkulator when you get back, thanks!
    <Reibot> Got it! Note stored for TomFubar.
    ** TomFubar has joined #test
    <Reibot> TomFubar, you have messages waiting!
    <Reibot> You, 2012-10-22 07:00:00 MST> Hey remember to check the status of the Gonkulator when you get back, thanks!

Messages are delivered in the context they were left - so if you leave a note in private, it will be delivered in private, and vice versa.

* Definitions (profiles) system

The definitions system allows you to store and retrieve arbitrary data. In Reibot's home server, this functionality is used to store character profiles for role playing purposes. Any information can be stored though - think of anything you need to display repetitively, such as channel rules, or the address for your clan's TF2 server, or a particularly funny quote that someone has inadvertently made...

    <you> ?learn Rules Don't whizz on the electric fence!
    <Reibot> Got it! I'll remember that info about Rules.
    ** Newbie has joined #test
    <you> Hi Newbie, make sure you read the server rules!
    <newbie> ?? rules
    <Reibot> [Rules] Don't whizz on the electric fence!

* Dice roller

Reibot's dice roller allows you to roll arbitrary combinations of dice with arbitrary mathematical functions carried out on the results. The command looks like:

 `(number of rolls)#(number of dice to roll)d(number of sides per dice)(math modifier)(options)(text)`

That looks really complicated, but here are some examples:

    `2#2d20+5 full TomFubar to hit`

This will roll 2 twenty-sided dice, twice, adding 5 to the result of each "set" of rolls. So you would get two numbers as a result, each result having 5 added to it. If that's still a bit confusing, think of it this way. Let's pretend you rolled two twenty-sided dice, and you got 10's each time. From Reibot, that would look like this:

   `<Reibot> 25: [10,10]+5 25: [10,10]+5 TomFubar to hit`

You did two sets of rolls, and 5 was added to each set.

The "options" bit right now only accepts "full", which means Reibot will show you the individual dice rolls rather than just the results.

* Website up checker

This utilizes the service at http://isup.me to check on the status of a random website. 

    <you> ?isup http://mywebsite.com
    <Reibot> mywebsite.com looks up from here!

* Steam up checker

Same thing, but checks for the availability of the Steam gaming service.

Requirements
-----------

* Ruby 2.1
* Cinch
* sqlite3
* Rails (by way of ActiveRecord.. I am trying to move away from this)
* Redis (both the gem, and a server configured)

* If you have the Bundler gem installed, you can run

    `bundle install`

 .. and all dependencies will be automatically pulled in for you.

Getting Started
---------------

* Edit rbreibot.yml to change the bot's name, channels to join, and so on. Note that this is a YAML formatted file, so whitespace matters! If you get a startup error, try pasting the entire contents of the file into something like https://yaml-online-parser.appspot.com/ to see if the file is good.

If you can't figure it out still, open an issue here and we'll get you sorted out.

* Run `rake db:migrate` to generate the initial database

* Run main.rb to start! Reibot should join the channel you specified and become available for use.


Plugins
-------
Individual plugin documentation can be seen on the wiki.


Repository Note
---------------
Due to some sensitive files being inadvertently pushed to the public repository, I decided to start over. The previous commit history was a bit of a disaster anyways, going all the way back to 2012 when I was still new to git as well as Ruby. A lot can change in 3 years, so this isn't a thing I should have to do again :)


License
-------
The MIT License (MIT)

Copyright (c) 2012-2015 by Michael Parks/TKWare Enterprises Ltd.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
