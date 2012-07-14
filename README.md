WritingStats: Tracking and Visualizing Writing Progress
=======================================================

WritingStats is a collection of scripts to automatically create statistics
from LaTeX documents and visualize them with an overall progress plots and a
plot of the daily speed of change.

Currently, this project provides a setup for a standard LaTeX environment in
combination with git version tracking.

Example
-------

Setup
-----

History
-------

The foundation of this project was already laid out when I wrote my master
thesis. To track my own progress, I wrote the initial version of these
scripts. However, back then, I was happily using Word and it's XML-based docx
file format. To be able to count words automatically, I used the
`docx2html.xsl` XSLT transformation, which also generated reasonably good HTML
from the Word files. The scripts are currently not adapted to use it, and
thus, Word is not supported anymore. However, pull requests to reintegrate it
are of course welcome.

License
-------

Copyright (c) 2012 Stefan Marr <mail@stefan-marr.de>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

