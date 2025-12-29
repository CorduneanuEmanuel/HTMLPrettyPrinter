import re
f=open('test.html', 'r')
tag_void=("area", "base", "br", "col", "embed", "hr", "img", "input", "link", "meta", "param", "source", "track", "wbr", "!DOCTYPE html", "!DOCTYPE")


fisier=f.readlines()
indentare=0
stiva=[]
i=0
while i < len(fisier):
    cuvant=fisier[i]
    m = re.match(r"^<!--(.)+-->", cuvant)  # cazul comentariu
    if m:
        fisier[i]='\t'*indentare+fisier[i]
    elif m := re.match(r'^\s*<(?!/)(\S+)(.)*>', cuvant):  # cazul <> inceput
        interior=m.group(1)
        print(interior)
        fisier[i]='\t'*indentare+fisier[i]
        if interior not in tag_void:
            stiva.append(interior)
            indentare+=1
    elif m := re.match(r'^\s*</(\S+)>', cuvant):  # cazul </> final
        interior=m.group(1)
        if interior != stiva[-1]:
            print('Nu s-a putut face identarea')
            print(interior ,stiva[-1])
            exit()
        indentare-=1
        fisier[i]='\t'*indentare+fisier[i]
        stiva.pop()
    else:
        m=re.match(r"(.)*", cuvant)
        fisier[i]='\t'*indentare+fisier[i]
        
    i+=1

fisier_iesire="".join(fisier)
g=open("out.txt", 'w')
g.write(fisier_iesire)

