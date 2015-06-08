#Goal: Collect all the chicken recipes from allrecipes.com which can be stored and used later

# q for quiet
# c for continuing where you left off
# r for recursive
# np for no parent
# nc for no clobber

# follow urls that match the regex -- only works in 1.14 Wget!!
wget -q -cr -np -nc --accept-regex allrecipes.com/Recipe/.*Chicken.* allrecipes.com &

# places lines that match the regex into output.txt - name, amount, ingredient, direction
grep -r '<h1 id="itemTitle" class="plaincharacterwrap fn" itemprop="name">.*</h1>\|<span id="lblIngAmount" class="ingredient-amount">.*</span>\|<span id="lblIngName" class="ingredient-name">.*</span>\|<span class="plaincharacterwrap break">.*</span>' allrecipes.com/Recipe | cat > output.txt

# takes out html stuff
sed -n 's/.*>\(.*\)\.<.*/\1/ p;s/.*>\(.*\)<.*/\1/ p'

