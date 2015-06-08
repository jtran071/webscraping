sed -n 's/.*>\(.*\)\.<.*/\1/ p;s/.*>\(.*\)<.*/\1/ p' $1 | cat > YummySed.txt
