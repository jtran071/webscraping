## Web scraping

This tutorial covers web-scraping with the basic Unix commands: `wget`, `grep`, and `sed`.
In particular, we will be using a site called [allrecipes] (http://allrecipes.com/?prop24=PN_Logo) to illustrate how to webscrape for recipes with chicken as the main ingredient, and then put all the ingredients and directions of the recipe into a single file.

### Web scraping and wget

To download a webpage we use [wget] (http://www.gnu.org/software/wget/manual/wget.html).
First, we need to download all of the recipes off the website, but that is *a lot* of recipes to download along with other irrelevant content.
To narrow it down to only chicken we can specify the [regular expression] (https://github.com/mikeizbicki/ucr-cs100/tree/2015spring/textbook/tools/bash/regex) in our command.
In the command below, `wget` downloads from links that start with `allrecipes.com/Recipe/` and with zero or more characters before and after `Chicken` as indicated by the `.*`.

```wget  -r -c -np -nc --accept-regex allrecipes.com/Recipe/.*Chicken.* allrecipes.com```
FIXME- TURN TO LIST/TABLE
Here is a quick rundown of the flags used above:


| Flag              | Description                                                                                                                                                                   |
|-------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `r` (recursive)   | This flag lets `wget` download the current web page and then continues to download any links on the web page, stopping  when there are no more links to retrieve.             |
| `c` (continue)    | We want to use this flag because it will tell `wget` to resume the download from where it was stopped earlier in case the process was stopped.                                |
|  `np` (no parent) | This flag prevents the download of subsequent links that lead to a directory other than the starting directory.                                                               |
| `nc` (no clobber) | This flag prevents `wget` from re-downloading the same file and instead preserves the original if another copy is found on the website.                                       |
| `--accept-regex`  | This flag will tell `wget` to download web pages with the specified regular expression as its URL to avoid files we do not want, which would save us both time and resources. |




Running the command specified above will display a download process in the terminal:

![my image](https://raw.githubusercontent.com/ktang012/hw4/master/pictures/wget.gif)

Websites have a file called [robot.txt] (http://www.gnu.org/software/wget/manual/html_node/Robot-Exclusion.html), which presents a policy that `wget`, and other similar tools, must follow. 
This may prevent `wget` from accessing or downloading from certain links when doing a recursive download.
You can ignore the `robots.txt` by passing in the flag `--execute robots=off` with `wget` to bypass the restrictions.
To run multiple instances of `wget` you may place a `&` at the end, which executes `wget` and places `wget` to run in the background. 
You can execute the command again to run another instance of `wget`, however, running too many instances may stress out the server so it is a good idea to only run a couple.
The time `wget` takes to download is dependent on both the site and your connection.
You can stop the download with `Ctrl + C` to cancel `wget` or  you can run `wget` in the background with `Ctrl + Z` and `bg`.
However, if you added a `&` you must directly kill the process via `pkill -9 wget` to stop it.

Once the download is done, you will have a folder called `allrecipes.com`.
Inside of this folder, it should contain another folder named `Recipe`, which contains all of the downloaded web content in each of their respective folders as seen here:

![my image](https://raw.githubusercontent.com/ktang012/hw4/master/pictures/display.png)

### HTML and grep
NOTE: SHOULD WE BE USING THE WORD PATTERN? OR HTML CODE
After downloading hundreds to thousands of files we need to get rid of all the extra text in the files we do not want.
The files we have downloaded are in [HTML](http://en.wikipedia.org/wiki/HTML) as seen in the `Yummy-Honey-Chicken-Kabobs` recipe file below.

![my image](https://raw.githubusercontent.com/ktang012/hw4/master/pictures/Yummy.png)

We want a readable text file with information on the name of the recipe, ingredients, and directions on how to make the recipe from all of the downloaded files.

We use `grep` and `sed` to traverse through the `allrecipes.com` folder to find only chicken recipe files and output the information we want into a separate text file.
[grep] (http://linux.die.net/man/1/grep) is a tool used to search for text in files, and for our purposes, we use `grep` to search for patterns in the HTML code.
HTML consists of tags enclosed in angle brackets like `<html>` and usually come in pairs such as `<h1>` and `</h1>` with text enclosed in the tags.
We can use this to our advantage when using `grep`.
To do this, we will first need to figure out which tags are associated with which part of the web page and the text the tags enclose.
In the following two gif, we right-click on the web page and click on inspect element to find the HTML tags that contain the recipe name, list of ingredients, and the directions.

NOTE TO SELF: CONTINUE FROM HERE
![my image](https://raw.githubusercontent.com/ktang012/hw4/master/pictures/yummy1.gif)

![my image](https://raw.githubusercontent.com/ktang012/hw4/master/pictures/yummy2.gif)

In the first gif, we see that the highlighted tag in the right window corresponds to the text being highlighted in the left window, which is related to the recipe name. 
In the second gif, we see similar highlighting, but this time it is related to the recipe ingredients.

These are the tags we are looking for in `Yummy-Honey-Chicken-Kabobs` for the recipe name and ingredients.
- `<h1 id="itemTitle" class="plaincharacterwrap fn" itemprop="name">Yummy Honey Chicken Kabobs</h1>`
- `<span id="lblIngAmount" class="ingredient-amount">1/4 cup</span>`
- `<span id="lblIngName" class="ingredient-name">vegetable oil</span>`

The directions are also formatted similarly to the recipe name and ingredients.
If we take a look at other recipes they would have the same tags and the only difference is the text enclosed by the tags.
We can use these tags to construct multiple regular expressions for `grep` to get the recipe names, ingredients, and directions.

Our general pattern in the HTML code should look like this:
- `<h1 id="itemTitle" class="plaincharacterwrap fn" itemprop="name"> __NAME__ </h1>`
- `<span id="lblIngAmount" class="ingredient-amount"> __AMOUNT__ </span>`
- `<span id="lblIngName" class="ingredient-name"> __INGREDIENT__ </span>`
- `<span class="plaincharacterwrap break"> __DIRECTION__ </span>`

The names `__NAME__`, `__AMOUNT__`,  `__INGREDIENT__`, and `__DIRECTION__` are
placeholders for the actual values for that specific recipe.

Here is the command we used to find the lines we want in the file.
FIXME: MAKE MULTILINE
```grep -r '<h1 id="itemTitle" class="plaincharacterwrap fn" itemprop="name">.*</h1>\|<span \
id="lblIngAmount" class="ingredient-amount">.*</span>\|<span id="lblIngName" class="ingredient-name">.*\
</span>\|<span class="plaincharacterwrap break">.*</span>' allrecipes.com/Recipe > output.txt```

Since we have multiple patterns we can append them together with the regular expression OR: `\|`.
The `\` at the end of the first two lines is a line break.point of sentence?

By doing a recursive `grep` call with multiple regular expressions as shown in the example above, `grep` scans through all the files in `allrecipes.com/Recipe` to look for the specified regular expressions.
Then, by redirecting the output of `grep` to `output.txt`, we successfully gathered the information we want.
Here is what the output looks like:

[YummyGrep1.png & YummyGrep2.png]

### Patterns and sed

After using `grep` to output the lines containing the text we want, we now want to delete all the HTML tags in the file.
This can be done with the help of [sed] (http://www.grymoire.com/Unix/Sed.html), a stream editor for modifying text, which also supports regular expressions
`sed` also supports regular expressions so we can construct a pattern similar to the one used in `grep` to delete the HTML tags.

In the pictures below, the green highlighting indicates the information we want, while the yellow highlighting indicates the HTML code we want to remove in the file located in `Yummy-Honey-Chicken-Kabobs`.

![my image](https://raw.githubusercontent.com/ktang012/hw4/master/pictures/YummyGrep1Marked.png)

![my image](https://raw.githubusercontent.com/ktang012/hw4/master/pictures/YummyGrep2Marked.png)

Next, we construct a regular expression that matches the HTML we want to remove.

`sed -n 's/.*>\(.*\)<.*/\1/ p’ input.txt | cat > output.txt`

The information we want are located in between `>` and `<` so the pattern above aims to remove everything BUT the texts in between the angle brackets which are enclosed in parenthesis.
It's a bit hard to read at first so we will run through the regular command.

- the first pattern is what we will be finding; the parenthesis capture whatever is inside of `.*>` and `<.*`
- the `\1` refers to the escaped parenthesis which we will be keeping

After using `sed` on the input file, the output file looks like this.

![my image](https://raw.githubusercontent.com/ktang012/hw4/master/pictures/YummySedFail.png)

Unfortunately, the directions are excluded in the output file.
Looking back at the input file, we notice that there is a period at the end of the direction as shown by the red circles below.
![my image](https://raw.githubusercontent.com/ktang012/hw4/master/pictures/YummyGrep2MarkedPeriod.png)

This is the reason why the directions are not included in the output file.
We can include the directions by introducing a second pattern into the sed command.

`sed -n 's/.*>\(.*\)<.*/\1/ p;s/.*>\(.*\)\.<.*/\1/ p’ input.txt | cat > output.txt`

The `;` will introduce a second pattern to sed.
The first part of ‘sed -n 's/.*>\(.*\)<.*/\1/ p’ is for the direction and the second part ‘s/.*>\(.*\)\.<.*/\1/ p’’ is for name and list of ingredients.
We included a period in the first part of `sed` to remove the period and everything after.
The key to using `sed` is noticing and experimenting with various patterns.
Our final output looks like this.

![my image](https://raw.githubusercontent.com/ktang012/hw4/master/pictures/YummySed.png)

#Tie everything together with a script

Although we have finished downloading all of the chicken recipes the output file is very disorganized and ugly.  
We want to be able to tell where the name of the recipe, the ingredients, and directions very clearly when reading our output file.  
In order to do this we have to use a bash script. 







