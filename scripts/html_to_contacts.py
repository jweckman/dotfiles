'''Takes in e.g. Telegram contacts HTML file and puts out VCARD version that can be imported more widely'''
from bs4 import BeautifulSoup

# VCARD SAMPLE

# BEGIN:VCARD
# VERSION:4.0
# N:Gump;Forrest;;Mr.;
# FN:Sheri Nom
# ORG:Sheri Nom Co.
# TITLE:Ultimate Warrior
# PHOTO;MEDIATYPE#image/gif:http://www.sherinnom.com/dir_photos/my_photo.gif
# TEL;TYPE#work,voice;VALUE#uri:tel:+1-111-555-1212
# TEL;TYPE#home,voice;VALUE#uri:tel:+1-404-555-1212
# ADR;TYPE#WORK;PREF#1;LABEL#"Normality\nBaytown\, LA 50514\nUnited States of America":;;100 Waters Edge;Baytown;LA;50514;United States of America
# ADR;TYPE#HOME;LABEL#"42 Plantation St.\nBaytown\, LA 30314\nUnited States of America":;;42 Plantation St.;Baytown;LA;30314;United States of America
# EMAIL:sherinnom@example.com
# REV:20080424T195243Z
# x-qq:21588891
# END:VCARD

# TELEGRAM EXPORT FORMAT

# </div>
# <div class="name bold">
#  NAME
# </div>
# <div class="details_entry details">
#  NUMBER

# TO IMPORT TO GNOME CONTACTS, USE EVOLUTION
# ARCH PACKAGE NAME IS: evolution

# evolution -i contacts.vcf
# opens up import GUI, does not work on mobile display at the moment

def vcard_string_4(name, number):
    s = 'BEGIN:VCARD\nVERSION:4.0\n'
    s = s + f"N:{name};;;;\n"
    s = s + f"TEL;TYPE#home,voice;VALUE#uri:tel:{number}\n"
    s = s + f"END:VCARD\n"
    return s

def vcard_string_2(name, number):
    '''This format worked better'''
    s = 'BEGIN:VCARD\nVERSION:2.1\n'
    s = s + f"N:{name}\n"
    s = s + f"TEL;HOME;VOICE:{number}\n"
    s = s + f"END:VCARD\n"
    return s


html_file = "telegram_desktop/DataExport_2022-08-13/lists/contacts.html"

with open(html_file, 'r') as fp:
    soup = BeautifulSoup(fp, 'html.parser')

soup.find_all("a", class_="sister")
names = []
numbers = []
for name in soup.find_all("div", class_='name bold'):
    names.append(name.string.strip())

for number in soup.find_all("div", class_= "details_entry details" ):
    numbers.append(number.string.strip())

names_numbers = dict(zip(names,numbers))

complete_vcard = ''

for name, number in names_numbers.items():
    complete_vcard = complete_vcard + vcard_string_2(name,number)

with open('contacts.vcf', 'w') as fp:
    fp.write(complete_vcard)


