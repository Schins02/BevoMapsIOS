import os, json, httplib, copy  

# connect to Parse ------------------------------------------------------------

connection = httplib.HTTPSConnection('api.parse.com', 443)
connection.connect()

wrapper = {}
search_dict = {}

# iterate through files in current dir get search file -------------------------

for root, dirs, files, in os.walk(os.getcwd()):
	for name in files : 
		if name.startswith("Search"):
	
			file = open(name)
			for line in iter(file):	

				split = line.split("_")
				search_dict[split[0]] = split[1][0:-1]


wrapper["SearchMap"] = search_dict
print wrapper

# update column in BuildingJSON table via PUT ---------------------------------- 

connection.request('PUT', '/1/classes/BuildingJSON/LBWuw7Pjhj', json.dumps(wrapper), {
 	"X-Parse-Application-Id": "7Z6Ys0bNVFV95NuisNLS8gUd7WGLEIR7AM1kWuWR",
   	"X-Parse-REST-API-Key": "jJg3QvhuBvzq1QTYum5OLl468ICWKtXYOr7MfNyY",
   	"Content-Type": "application/json"
})

result = json.loads(connection.getresponse().read())
print result
