rb-dayone
<<<<<<< HEAD
===========

A means to create DayOne entries (skipping the command line) in ruby.

Features
--------

* Simple syntax
* No dependencies outside of having DayOne installed
* You don't need to bother with XML yourself?

Examples
--------

  entry = DayOne::Entry.new
  entry.entry_text = <<-end
  Here is my entry, isn't it pretty?
  end
  entry.starred = true
  entry.create!

Requirements
------------

* You should probably have DayOne installed so you can actually create some DayOne entries.
* Access to `uuidgen` in your PATH (rb-dayone will freak out otherwise)

Install
-------

`gem install rb-dayone`

Author
------

Original author: Jan-Yves Ruzicka

Roadmap
-------

* Actually working!
* Binary with the ability to set DayOne location
* Image support

License
-------

Copyright (c) 2012 Jan-Yves Ruzicka

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
=======
=========

A ruby library for creating (and, one day, editing and removing) DayOne.app entries
>>>>>>> d4606a817c5f5757f6b5e4c996d7f61cb0d023b1
