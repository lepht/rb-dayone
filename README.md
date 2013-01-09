# rb-dayone

A means to create DayOne entries in ruby.

## Examples

You can create an entry pretty simply:

    e = DayOne::Entry.new "# Hello, world!"
  
You can also set up other values via a hash:

    e = DayOne::Entry.new "I totally posted this an hour ago", creation_date: Time.now-3600

Otherwise, you can set values using simple accessor methods, as you'd expect:

    e = DayOne::Entry.new "I need to remember this."
    e.starred = true

When you're ready to save your entry, just run the `create!` method:

    e.create!

## Install

    gem install rb-dayone

## Author

Original author: [Jan-Yves Ruzicka](http://www.1klb.com). Get in touch [via email](mailto:janyves.ruzicka@gmail.com).

## History

### 0.5.0 / 2013-01-09

* [NEW] Added support for tagging entries via `Entry#tag`, `Entry#tags`, and `Entry#add_tags_from_entry_text`.
* [REMOVED] Got rid of the binary. You can probably make a better library on your own.

## 0.4.1 / 2012-11-14

* [FIXED] rb-dayone was looking in the wrong place for preferences
* [FIXED] new preference files not json-parseable. Swapped to XML/Nokogiri

## 0.4.0 / 2012-10-22

* Added image support

## 0.3.3 / 2012-08-17

* [FIXED] LibXML will now accept UTF-8 characters in journal entries.
* Added the command "repair" to the dayone binary, which will at least repair *my* damage.
* Added the command "verify" to the dayone binary, which I at least find helpful.
* Added a post-install note telling people upgrading from <= 0.2.0 to repair.

## 0.3.2 / 2012-08-16

* Switched from REXML to LibXML-ruby for XML parsing. Now accepts ampersands in entries, as well as UTF-8. Rejoice!

## 0.3.1 / 2012-08-16

* [FIXED] Minor bugfixes
* [FIXED] REXML will no longer kill the whole program if it can't parse a journal file.

## 0.3.0 / 2012-08-16

* [FIXED] Fixed several bugs in Builder xml output, including:
  * Output of trailing <target />
  * Output of malformed DOCTYPE
* You can now import existing DayOne entries and search them

## 0.2.0 / 2012-08-14

* Now auto-detects DayOne journal location from your plist file

## 0.1.7 / 2012-08-13

* The dayone binary can now add entries to your journal
* [FIXED] Managed to break the gem's include in 0.1.6, and because I'm a terrible amateur at all this, didn't pick up on it.

## 0.1.6 / 2012-08-13

* Updated documentation so YARD would generate nice rdocs
* dayone binary now uses the Commander gem
* Now using a Manifest file rather than globbing in whole directories

## 0.1.5 / 2012-08-12

* [FIXED] Ouch, horrid horrid gemspec and readme. Let's make them prettier.

## 0.1.4 / 2012-08-12

* Added a couple more tests for better coverage

## 0.1.3 / 2012-08-12

* Removed the SimpleXML class, now using the Builder gem

## 0.1.2 / 2012-08-12

* [FIXED] Actual testing on my own system

## 0.1.1 / 2012-08-07

* [FIXED] DayOne constants are now `attr_accessors` - set them yourself if you wish!

## 0.1.0 / 2012-08-06

* Added binary
* Support for DayOne locations
* Uploaded to github!

## 0.0.1 / 2012-08-05

* Started development

## To do

* Location support?
* Switch from using two different XML libraries to one XML library.