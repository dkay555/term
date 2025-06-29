## To-Do

### Pfade
acc_eigene = /storage/emulated/0/MonopolyGo/Accounts/Eigene/
acc_kunden = /storage/emulated/0/MonopolyGo/Accounts/Kunden/
acc_datapath = /data/data/com.scopely.monopolygo/files/DiskBasedCacheDirectory/WithBuddies.Services.User.0Production.dat
acc_infos = /data/data/com.scopely.monopolygo/shared_prefs/com.scopely.monopolygo.v2.playerprefs.xml
acc_eigene_infos = /storage/emulated/0/MonopolyGo/Accounts/Eigene/Accountinfos.json
acc_kunden_infos = /storage/emulated/0/MonopolyGo/Accounts/Kunden/Kundeninfos.json

### Aufbau von Accountverwaltung
1. Account wiederherstellen
	1.1. Eigene Accounts
	1.2. Kunden Accounts
2. Account sichern
	2.1. Eigener Account
	2.2. Kunden Account
3. Infos ändern
	3.1. Eigener Account
	3.2. Kunden Account
4. Kopiere Links
5. Backup & Restore

### Beshreibung der Funktionen
1. Account wiederherstellen
	1.1. Eigene Accounts
		-> Zeige Liste der Ordner in "acc_eigene". Jeder Ordner steht für einen Account.
		-> Beende die App "com.scopely.monopolygo"
		-> Vom gewählten Ordner den Inhalt (WithBuddies.Services.User.0Production.dat) nach "acc_datapath" kopieren.
		-> Frage ob "com.scopely.monopolygo" gestratet werden soll.
	1.2. Kunden Accounts
		-> Selber Prozess wie 1.1. nur das aus dem Pfad "acc_kunden" gewählt wird.
2. Account sichern
	1.2. Eigene Accounts
		-> Daten werden in acc_eigene_infos gespeichert im Format:
{"interneid":"Max01","userid":"123456789","datum":"2024-05-15","shortlink":"https://go.babixgo.de/babixgo001","notiz":""}
		interneid: Wird abgefragt. Name+Nummerierung. Startet bei 01.
		userid: Wird aus "acc_infos" extrahiert. <string name="Scopely.Attribution.UserId">\K[0-9]+
		datum: das aktuelle datum 
		shortlink: api_url="https://api.short.io/links/tweetbot?domain=go.babixgo.de&path="§interneid"&originalURL=${monopolygo://add-friend/userid}&title=interneid&apiKey=sk_MaQODQPO0HKJTZF1"
response=$(curl -s -w "%{http_code}" --request GET --url "$api_url" --header "Authorization: sk_MaQODQPO0HKJTZF1")
		-> acc_datapath wird nach  /storage/emulated/0/MonopolyGo/Accounts/Eigene/"interneid" kopiert
		-> Es muss geprüft werden ob die UserId bereits hinterlegt ist. 