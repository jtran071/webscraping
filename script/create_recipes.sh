# Creates a directory "Chicken_Recipes" which contains text files of the recipes
# Duplicate recipes will be ignored
# Inside the file it should be formatted as:

# --------------------------------------------------
# Name
# --------------------------------------------------
# <NAME>
# --------------------------------------------------
# Ingredients
# --------------------------------------------------
# <AMOUNT>
# <INGREDIENT>
# --------------------------------------------------
# Directions
# --------------------------------------------------
# <DIRECTION>
# --------------------------------------------------

if [ ! -d Chicken_Recipes ]
    then
        mkdir Chicken_Recipes
fi

for i in $(ls allrecipes.com/Recipe); do
    echo "--------------------------------------------------" >> "Chicken_Recipes/$i.txt"
    echo "Name" >> "Chicken_Recipes/$i.txt"
    echo "--------------------------------------------------" >> "Chicken_Recipes/$i.txt"

    grep '<h1 id="itemTitle" class="plaincharacterwrap fn" itemprop="name">.*</h1>' 'allrecipes.com/Recipe/${i}/Detail.aspx.*' |
        sed -n 's/.*>\(.*\)\.<.*/\1/ p;s/.*>\(.*\)<.*/\1/ p' >> "Chicken_Recipes/$i.txt"

    echo "--------------------------------------------------" >> "Chicken_Recipes/$i.txt"
    echo "Ingredients" >> "Chicken_Recipes/$i.txt"
    echo "--------------------------------------------------" >> "Chicken_Recipes/$i.txt"

    grep '<span id="lblIngAmount" class="ingredient-amount">.*</span>\|<span id="lblIngName" class="ingredient-name">.*</span>' \
        'allrecipes.com/Recipe/${i}/Detail.aspx.*' |
        sed -n 's/.*>\(.*\)\.<.*/\1/ p;s/.*>\(.*\)<.*/\1/ p' >> "Chicken_Recipes/$i.txt"

    echo "--------------------------------------------------" >> "Chicken_Recipes/$i.txt"
    echo "Directions" >> "Chicken_Recipes/$i.txt"
    echo "--------------------------------------------------" >> "Chicken_Recipes/$i.txt"

    grep -r '<span class="plaincharacterwrap break">.*</span>' 'allrecipes.com/Recipe/${i}/Detail.aspx.*' |
        sed -n 's/.*>\(.*\)\.<.*/\1/ p;s/.*>\(.*\)<.*/\1/ p' >> "Chicken_Recipes/$i.txt"

    echo "--------------------------------------------------" >> "Chicken_Recipes/$i.txt"
    done
