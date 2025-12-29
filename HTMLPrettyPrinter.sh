# ©Corduneanu Emanuel, to be used freely
# HTMLPrettyPrinter takes a raw html file and will indent

tag_void=("area" "base" "br" "col" "embed" "hr" "img" "input" "link" "meta" "param" "source" "track" "wbr" "!DOCTYPE html")

prima=$(sed -e "s/>/>\n/g; s/</\n</g" "$1" )
prima_formatare=$(echo "$prima" | sed '/^$/d')


mapfile -t fisier < <(echo "$prima" | sed '/^$/d')
lungime=${#fisier[@]}
identare=0
stiva=()
i=0
while [ $i -lt $lungime ]; do
    cuvant="${fisier[$i]}"
    regex1="^<!--(.+)-->"
    regex2='^[[:space:]]*<([^[:space:]>]+)(.*)>'
    regex_exclude='[[:space:]]*</(.)*>'
    regex3='^</([^[:space:]>]+)>'
    
    if [[ $cuvant =~ $regex1 ]]; then
        c="${fisier[$i]}"
        rezultat=''
        for ((j=1; j<=identare; j++)); do
            rezultat+=$'\t'
        done
        rezultat+=$c
        fisier[$i]="$rezultat"
    
    elif [[ ! $cuvant =~ $regex_exclude  ]] && [[ $cuvant =~ $regex2 ]]; then
        interior="${BASH_REMATCH[1]}"
        # echo $interior
        c="${fisier[$i]}"
        rezultat=''
        for ((j=1; j<=identare; j++)); do
            rezultat+=$'\t'
        done
        rezultat+=$c
        fisier[$i]="$rezultat"

        gasit=false
        for tag in "${tag_void[@]}"; do
            if [[ "$tag" == "$interior" ]]; then
                gasit=true
                break 
            fi
        done
        if [ "$gasit" = false ]; then
            stiva+=("$interior")
            identare=$((identare+1))
        fi
        
    elif [[ $cuvant =~ $regex3 ]]; then
        interior="${BASH_REMATCH[1]}"
        # echo "$interior ${stiva[-1]}"
        if [[ "$interior" != "${stiva[-1]}" ]]; then
            echo "Nu s-a putut face identarea"
            exit 1
        fi
        identare=$((identare-1))
        c="${fisier[$i]}"
        rezultat=''
        for ((j=1; j<=identare; j++)); do
            rezultat+=$'\t'
        done      
        rezultat+=$c
        fisier[$i]="$rezultat"
        length=$((${#stiva[@]}-1))
        unset "stiva[$length]"
    
    else 
        c="${fisier[$i]}"
        rezultat=''
        for ((j=1; j<=identare; j++)); do
            rezultat+=$'\t'
        done
        rezultat+=$c
        fisier[$i]="$rezultat"
    fi
    
    ((i++))
done


output=""
for val in "${fisier[@]}"; do
    output="$output"$'\n'"$val"
done

echo "$output" > output.html
