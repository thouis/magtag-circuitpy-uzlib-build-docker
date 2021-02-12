Docker to build CircuitPython on Adafruit MagTag with uzlib included.

This is my quick and dirty dockerfile to build a CircuitPython UF2
that included uzlib for the Adafruit MagTag.  I probably broke
something with the minor edits I made, and I certainly didn't do the
right thing to deal with different languages being included.  I've put
it on github as a possible reference for others, though probably a bad
one.

It's mostly cribbed from the Adafruit build actions on github.
