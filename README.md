# rb-dayone

A means to create DayOne entries in ruby.

Examples
--------

You can create an entry pretty simply, by passing in your entry text:

  e = DayOne::Entry.new "# Hello, world!"
  
You can also set up other values via a hash:

  e = DayOne::Entry.new "I totally posted this an hour ago", creation_date: Time.now-3600

Otherwise, you can set values using simple accessor methods, as you'd expect:

  e = DayOne::Entry.new "I need to remember this."
  e.starred = true

When you're ready to save your entry, just run the `create!` method:

  e.create!

Install
-------

`gem install rb-dayone`

Author
------

Original author: Jan-Yves Ruzicka

Roadmap
-------

* Image support
* Location support?
* Auto-location detection

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
