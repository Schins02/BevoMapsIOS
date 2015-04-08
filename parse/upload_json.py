import os, json, httplib, copy

# connect to Parse ------------------------------------------------------------

connection = httplib.HTTPSConnection('api.parse.com', 443)
connection.connect()

# iterate through files in dir and upload to parse ----------------------------
# format: file name => building => GDC.txt ------------------------------------

# set up dictionary and list to build json ------------------------------------

url_data = {}
url_data["pk"] = "jsonObj"
url_data["Buildings"] = {}
marker_list_fields = ["shortName", "longName", "latitude", "longitude", "thumbnail"]

# iterate through files in current dir and load json --------------------------

for root, dirs, files, in os.walk(os.getcwd()) :
	for name in files : 
		if(name.endswith(".txt")):

			#format: file name => building => GDC.txt
			#text in file => floor_URL => 01_www.imageURL.com
			#newline needed at end of file or a char will get cut off the last URL

			number_of_floors = 0
			building_name = name[0:-4]
			url_data["Buildings"][building_name] = {}

			file = open(name)
			for line in iter(file) :

				floor_and_url = line.split("_")
				if floor_and_url[0] not in marker_list_fields :
					url_data["Buildings"][building_name][floor_and_url[0]] = floor_and_url[1][0:-1]


print url_data

# POST data to BuildingJSON table --------------------------------------------- 

connection.request('POST', '/1/classes/BuildingJSON', json.dumps(url_data), {
 	"X-Parse-Application-Id": "7Z6Ys0bNVFV95NuisNLS8gUd7WGLEIR7AM1kWuWR",
   	"X-Parse-REST-API-Key": "jJg3QvhuBvzq1QTYum5OLl468ICWKtXYOr7MfNyY",
   	"Content-Type": "application/json"
})

result = json.loads(connection.getresponse().read())
print result
