a='{
	"Name": "Techdays",
	"Description": "Techdays",
	"Category": "Others",
	"ImageUrl": "https://cdn.discordapp.com/attachments/623454766202093580/650382190017773579/techdays2019.png",
	"City": "Aveiro",
	"SubCity": "Centro de Exposições",
	"Lat": 40.634091,
	"Lon": -8.631289,
	"Date": 1594857600
}'

b='{
	"Name": "Super Bock Super Rock",
	"Description": "Super Bock Super Rock",
	"Category": "Concert",
	"ImageUrl": "https://assets.bondlayer.com/nh1jeybtuf/_assets/nhykakttugnrkgyttk6uz.png",
	"City": "Setubal",
	"SubCity": "Praia do Meco",
	"Lat":  38.488906,
	"Lon":  -9.182083,
	"Date": 1594857600
}'

c='{
    "Name": "VOA",
    "Description": "VMF, mas em Lisboa!",
    "Category": "Concert",
    "ImageUrl": "https://media.resources.festicket.com/www/photos/11253-artwork.jpg",
    "City": "Lisboa",
    "SubCity": "Estádio Nacional",
    "Lat":  38.708772,
    "Lon":  -9.262458,
    "Date": 1594857600
}'

d='{
    "Name": "Iron Maiden",
    "Description": "Legacy Beast Tour",
    "Category": "Concert",
    "ImageUrl": "https://i.ytimg.com/vi/amT3IexbjzI/maxresdefault.jpg",
    "City": "Lisboa",
    "SubCity": "Estádio Nacional",
    "Lat":  38.708772,
    "Lon":  -9.262458,
    "Date": 1594857600
}'

e='{
    "Name": "MEO Mares Vivas",
    "Description": "MEO Mares Vivas",
    "Category": "Concert",
    "ImageUrl": "https://upload.wikimedia.org/wikipedia/pt/thumb/c/c9/MEOMaresVivas.png/250px-MEOMaresVivas.png",
    "City": "Vila Nova de Gaia",
    "SubCity": "Parque de S. Paio",
    "Lat": 41.134456,
    "Lon": -8.666583,
    "Date": 1594857600
}'

f='{

    "Name": "Estoril Praia – CD Feirense",
    "Description": "Estoril Praia – CD Feirense",
    "Category": "Sport",
    "ImageUrl": "https://bolimg.blob.core.windows.net/producao/imagens/espectaculos/cartaz69243_grande.jpg",
    "City": "Estádio António C. Mota a",
    "SubCity": "Estádio António C. Mota ",
    "Lat": 38.701808,
    "Lon": -9.394943,
    "Date": 1594857600
}'

g='{

    "Name": "São Silvestre da Figueira da Foz",
    "Description": "A São silvestre da Figueira da Foz é um evento promovido pela Câmara Municipal da Figueira da Foz e organizado pela Last Lap Eventos e Comunicação Lda.",
    "Category": "Sport",
    "ImageUrl": "https://bolimg.blob.core.windows.net/producao/imagens/espectaculos/cartaz72086.jpg",
    "City": "Vila Nova de Gaia",
    "SubCity": "Parque de S. Paio",
    "Lat": 41.134456,
    "Lon": -8.666583,
    "Date": 1594857600
}'

h='{

    "Name": "Cross Jamor 2020",
    "Description": "Com o apoio da Câmara Municipal de Oeiras, da Associação de Atletismo de Lisboa e Instituto Português do Desporto e Juventude, o Cross do Jamor terá lugar na Pista de corta-mato do Centro Desportivo Nacional do Jamor, onde se realizará em simultâneo o Campeonato Regional de Corta-Mato Curto de Lisboa.",
    "Category": "Sport",
    "ImageUrl": "https://bolimg.blob.core.windows.net/producao/imagens/espectaculos/cartaz72819_grande.jpg",
    "City": "Pista de Cross do Jamor",
    "SubCity": "Pista de Cross do Jamor",
    "Lat": 38.715871,
    "Lon": -9.285724,
    "Date": 1594857600
}'

i='{

    "Name": "Chicago",
    "Description": "Chicago é um dos musicais com maior sucesso no mundo. Baseado numa peça de teatro com o mesmo nome, escrita pela repórter Maurine Dallas Watkins, o musical foi distinguido com 6 Prémios Tony e seis Óscares para a adaptação para cinema de Rob Marshall. A produção original, coreografada por Bob Fosse, estreou-se na Broadway em 1975 e teve mais de 900 apresentações, tendo percorrido mais de 24 países e sendo interpretado em 12 línguas diferentes.",
    "Category": "Theater",
    "ImageUrl": "https://bolimg.blob.core.windows.net/producao/imagens/espectaculos/cartaz65476.jpg",
    "City": "Teatro da Trindade INATEL",
    "SubCity": "Teatro da Trindade INATEL",
    "Lat": 41.134456,
    "Lon": -8.666583,
    "Date": 1594857600
}'

j='{
    "Name": "O Quebra-Nozes — Russian Classical Ballet",
    "Description": "Russian Classic Ballet, a prestigiada companhia de Moscovo, dirigida pela famosa bailarina Evgeniya Bespalova, regressa a Portugal para apresentar uma das obras-primas do bailado clássico O QUEBRA-NOZES, uma narrativa encantadora que desperta o nosso imaginário, remetendo-nos para o reino da fantasia.",
    "Category": "Theater",
    "ImageUrl": "https://bolimg.blob.core.windows.net/producao/imagens/espectaculos/cartaz66039.jpg",
    "City": "Universidade de Coimbra - Teatro Académico de Gil Vicente",
    "SubCity": "Universidade de Coimbra - Teatro Académico de Gil Vicente",
    "Lat": 40.207178,
    "Lon": -8.411475,
    "Date": 1594857600
}'

k='{
    "Name": "O LAGO DOS CISNES | MOSCOW STATE BALLET | COM ORQUESTRA SINFÓNICA",
    "Description": "O LAGO DOS CISNES | MOSCOW STATE BALLET | COM ORQUESTRA SINFÓNICA",
    "Category": "Theater",
    "ImageUrl": "https://bolimg.blob.core.windows.net/producao/imagens/espectaculos/cartaz68936.jpg",
    "City": "Coliseu de Lisboa ,
    "SubCity": "Coliseu de Lisboa",
    "Lat": 38.716823,
    "Lon": -9.140172,
    "Date": 1594857600
}'

curl -H "Content-Type: application/json" -d "$a" -X POST 168.63.30.192:5000/create_event
curl -H "Content-Type: application/json" -d "$b" -X POST 168.63.30.192:5000/create_event
curl -H "Content-Type: application/json" -d "$c" -X POST 168.63.30.192:5000/create_event
curl -H "Content-Type: application/json" -d "$d" -X POST 168.63.30.192:5000/create_event
curl -H "Content-Type: application/json" -d "$e" -X POST 168.63.30.192:5000/create_event
curl -H "Content-Type: application/json" -d "$f" -X POST 168.63.30.192:5000/create_event
curl -H "Content-Type: application/json" -d "$g" -X POST 168.63.30.192:5000/create_event
curl -H "Content-Type: application/json" -d "$h" -X POST 168.63.30.192:5000/create_event
curl -H "Content-Type: application/json" -d "$i" -X POST 168.63.30.192:5000/create_event
curl -H "Content-Type: application/json" -d "$j" -X POST 168.63.30.192:5000/create_event
curl -H "Content-Type: application/json" -d "$k" -X POST 168.63.30.192:5000/create_event


#./stopall.sh -d && git pull && ./bootup.sh -b

#docker-compose down && sudo rm -rf /dev/shm/db_composer/ && docker-compose up -d db && sleep 20 && docker-compose up -d app
