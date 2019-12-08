a='{
	"Name": "Techdays",
	"Description": "Techdays",
	"Category": "Technology",
	"ImageUrl": "https://cdn.discordapp.com/attachments/623454766202093580/650382190017773579/techdays2019.png",
	"City": "Aveiro",
	"SubCity": "Centro de Exposições",
	"Lat": 40.634091, 
	"Lon": -8.631289,
	"Date": 1570665600
}'

b='{
	"Name": "Super Bock Super Rock",
	"Description": "Super Bock Super Rock",
	"Category": "Music Festival",
	"ImageUrl": "https://assets.bondlayer.com/nh1jeybtuf/_assets/nhykakttugnrkgyttk6uz.png",
	"City": "Setubal",
	"SubCity": "Praia do Meco",
	"Lat":  38.488906,  
	"Lon":  -9.182083,
	"Date": 1563235200
}'

c='{
    "Name": "VOA",
    "Description": "VMF, mas em Lisboa!",
    "Category": "Music Festival",
    "ImageUrl": "https://media.resources.festicket.com/www/photos/11253-artwork.jpg",
    "City": "Lisboa",
    "SubCity": "Estádio Nacional",
    "Lat":  38.708772, 
    "Lon":  -9.262458,
    "Date": 1562025600
}'

d='{
    "Name": "Iron Maiden",
    "Description": "Legacy Beast Tour",
    "Category": "Music Festival",
    "ImageUrl": "https://i.ytimg.com/vi/amT3IexbjzI/maxresdefault.jpg",
    "City": "Lisboa",
    "SubCity": "Estádio Nacional",
    "Lat":  38.708772, 
    "Lon":  -9.262458,
    "Date": 1563840000
}'

e='{
    "Name": "MEO Mares Vivas",
    "Description": "MEO Mares Vivas",
    "Category": "Music Festival",
    "ImageUrl": "https://upload.wikimedia.org/wikipedia/pt/thumb/c/c9/MEOMaresVivas.png/250px-MEOMaresVivas.png",
    "City": "Vila Nova de Gaia",
    "SubCity": "Parque de S. Paio",
    "Lat": 41.134456, 
    "Lon": -8.666583,
    "Date": 1563321600
}'


curl -H "Content-Type: application/json" -d "$a" -X POST 168.63.30.192:5000/create_event
curl -H "Content-Type: application/json" -d "$b" -X POST 168.63.30.192:5000/create_event
curl -H "Content-Type: application/json" -d "$c" -X POST 168.63.30.192:5000/create_event
curl -H "Content-Type: application/json" -d "$d" -X POST 168.63.30.192:5000/create_event
curl -H "Content-Type: application/json" -d "$e" -X POST 168.63.30.192:5000/create_event


#./stopall.sh -d && git pull && ./bootup.sh -b

#docker-compose down && sudo rm -rf /dev/shm/db_composer/ && docker-compose up -d db && sleep 20 && docker-compose up -d app
