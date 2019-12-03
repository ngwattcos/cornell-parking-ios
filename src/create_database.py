import requests
import json

LOCAL_URL = 'http://0.0.0.0:5000'

BUILDING = 3
LEVEL = 3
SPOT = [{'Type':'Accessible', 'Count':10},
	 {'Type':'Green', 'Count':10},
	 {'Type':'General', 'Count':30}]

for building in range(BUILDING):
	building_index = building + 1
	BUILDING_BODY = {
	  "shortName": 'B' + str(building_index),
	  "longName": 'Building' + str(building_index)
	}	
	requests.post(LOCAL_URL + '/api/building/', data=json.dumps(BUILDING_BODY))

	for level in range(LEVEL):
		level_index = level + 1
		LEVEL_BODY = {
		  "levelName": BUILDING_BODY['shortName'] + 'L' + str(level_index),
		  "accessible": SPOT[0]['Count'],
		  "green":  SPOT[1]['Count'],
		  "general":  SPOT[2]['Count']
		}		
		requests.post(LOCAL_URL + '/api/building/' + str(building_index) + 'level' + '/', data=json.dumps(LEVEL_BODY))

		for accessible in range(LEVEL_BODY['accessible']):
			ACCESSIBLE_BODY = {
			  "parkType": "accessible",
			  "name": "Accessible" + str(accessible + 1),
			  "emptyFlag": 1
			}
			requests.post(LOCAL_URL + '/api/level/' + str(level_index) + 'spot' + '/', data=json.dumps(ACCESSIBLE_BODY))

		for green in range(LEVEL_BODY['green']):
			GREEN_BODY = {
			  "parkType": "green",
			  "name": "Green" + str(green + 1),
			  "emptyFlag": 1
			}
			requests.post(LOCAL_URL + '/api/level/' + str(level_index) + 'spot' + '/', data=json.dumps(GREEN_BODY))

		for general in range(LEVEL_BODY['general']):
			GENERAL_BODY = {
			  "parkType": "general",
			  "name": "General" + str(general + 1),
			  "emptyFlag": 1
			}			
			requests.post(LOCAL_URL + '/api/level/' + str(level_index) + 'spot' + '/', data=json.dumps(GENERAL_BODY))
