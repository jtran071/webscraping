## Web scraping

This tutorial covers web-scraping with the basic Unix programs: `wget`, `grep`, and `sed`.
By combining all of these relatively simple programs we can collect, parse, and use the data
in more complicated programs.

### Web scraping and Wget

To download a webpage do: `wget [url]` and view the downloaded content with an editor.
In our example, we’ll be web scraping for chicken recipes on [allrecipes.com] (allrecipes.com) and compiling
it into a single file.
First we’ll need to download all of the recipes off the website, but that’s *a lot* of recipes to
download as well as other irrelevant content.
To narrow it down to only chicken we can specify the regular expression (regex) in our command.

`wget -q -r -c -np -nc --accept-regex allrecipes.com/Recipe/.*Chicken.* allrecipes.com`

Here’s a quick rundown of the flags used above:
- `-q` (quiet) will stop the output
- `-r` (recursive) does recursive downloading
- `-c` (continue) will resume downloading if it was stopped earlier
- `-np` (no-parent) prevents downloading from parent links
- `-nc` (no-clobber) prevents the downloading of the same web file
- `--accept-regex` will only follow web pages with the specified regular expression as its url

The time it takes is dependent on both the site and your connection.
It should take around an hour to download all chicken recipes from the site.
You can stop the download with `Ctrl + C` and run it again later
or run it in the background with `Ctrl + Z` and `bg`.
Once it is done, you will have a folder `allrecipes.com`.
Inside of it should contain another folder `Recipe` which contains all the
web content downloaded, each in their respective folders.

### HTML and Grep

Now we will need to figure out which tags are associated with which part of the web page
and get rid of everything else we don't want. Grep can do this for us.

[THREE PICTURES OF INSPECTING ELEMENTS ON SOME RECIPE]

To find which part of the web page is associated with which HTML tag simply right-click
and inspect element on the web page as shown.
By looking at the tags that enclose the data you want to extract, you can get an idea of
what the pattern looks like.
In our case we’ll be trying to find the following tags:
- `<h1 id="itemTitle" class="plaincharacterwrap fn" itemprop="name"> __NAME__ </h1>`
- `<span id="lblIngAmount" class="ingredient-amount"> __AMOUNT__ </span>`
- `<span id="lblIngName" class="ingredient-name"> __INGREDIENT__ </span>`
- `<span class="plaincharacterwrap break"> __DIRECTION__ </span>`

The names `__NAME__`, `__AMOUNT__`,  `__INGREDIENT__`, and `__DIRECTION__` are
simply placeholders for the actual values there for that certain recipe.
Since we have multiple patterns we can append them together with the regex OR: ‘\|’.

Example:
`<pattern1>\|<pattern2>’

By doing a recursive grep call and then redirecting it to another file we have successfully 
compiled all the information we want.

### Patterns and Sed

Now we need to clean up all the extra HTML text in our file.
Sed can help us find and remove those HTML patterns.
Sed also supports regex, and depending on the patterns, it may get a bit messy.

[PICTURE OF UNCLEAN HERBED CHICKEN NUGGETS TEXT]

We will need to find a pattern that matches what we’re trying to remove.

`sed -n 's/.*>\(.*\)<.*/\1/ p’`

We can see that the text we want are located in between `>` and `<` so the pattern above aims
to remove everything BUT the text in between the angle brackets.
It's a bit hard to read at first so we'll run through the command.

- the first pattern is what we will be finding; the parenthesis capture whatever is inside of `.*>` and `<.*`
- the `\1` refers to the escaped parenthesis which we will be keeping

[PICTURE OF EVERYTHING BUT DIRECTIONS CLEAN TEXT]

Oops! We weren’t able to include the directions.
Notice that there are several angle brackets that enclose the text for directions.

[PICTURE OF DIRECTIONS HTML AND ARROW TO PATTERN]

We can get the directions by including a second pattern into the sed command. 

`sed -n 's/.*>\(.*\)\.<.*/\1/ p;s/.*>\(.*\)<.*/\1/ p'`

The `;` will introduce the second pattern to sed.
The `__DIRECTION__` section did not show up in the previous command because there is a difference in the pattern,
more specifically the period in the directions section.
So we included a period in the pattern and had it remove the period and everything after.
The key to using sed is noticing and experimenting with the patterns.

### Resources
- [Wget manual page] (http://www.gnu.org/software/wget/manual/wget.html) for 
 more information on wget.
- [Grep manual page] (http://linux.die.net/man/1/grep) for more information on grep.
- [Sed tutorial] (http://www.grymoire.com/Unix/Sed.html) for more information on sed.
- [Regular expressions tutorial] (https://github.com/mikeizbicki/ucr-cs100/tree/2015spring/textbook/tools/bash/regex) for more
information on regex.


