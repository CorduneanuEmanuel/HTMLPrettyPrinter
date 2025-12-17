
# text="$(cat "$1")"

# echo "$text"

tag_void=("area" "base" "br" "col" "embed" "hr" "img" "input" "link" "meta" "param" "source" "track" "wbr" "!DOCTYPE html")

sed -e "s/>/>\n/g; s/</\n</g" "$1" | sed '/^$/d'



# grep -E -o "(<(.)*>$)" "$1" | while read linie 
# do
#     echo $linie


# done

