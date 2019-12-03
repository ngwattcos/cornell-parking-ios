
""" This program creates a database of parking with 3 buildings, 
	each building has 3 levels, and each level has 10 accessible, 
	10 green, and 30 general parking spots.

	formulas to calculate id for buildings, levels and spots:
	building_id = building + 1
	level_id = 3 * building + level + 1
	accessible_id = 150*building +50*level + accessible + 1
	green_id = 150*building +50*level + 10 + green + 1	
	general_id = 150*building +50*level + 20 + general + 1	
"""

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
	  'shortName': 'B' + str(building_index),
	  'longName': 'Building' + str(building_index)
	}	
	requests.post(LOCAL_URL + '/api/building/', data=json.dumps(BUILDING_BODY))

	for level in range(LEVEL):
		level_index = level + 1
		LEVEL_BODY = {
		  'levelName': BUILDING_BODY['shortName'] + 'L' + str(level_index),
		  'accessible': SPOT[0]['Count'],
		  'green':  SPOT[1]['Count'],
		  'general':  SPOT[2]['Count']
		}		
		requests.post(LOCAL_URL + '/api/building/' + str(building_index) + '/level/', data=json.dumps(LEVEL_BODY))

		for accessible in range(LEVEL_BODY['accessible']):
			accessible_index = accessible + 1
			ACCESSIBLE_BODY = {
			  'parkType': 'accessible',
			  'name': 'Accessible' + str(accessible_index),
			  'emptyFlag': 1
			}
			requests.post(LOCAL_URL + '/api/level/' + str(level_index) + '/spot/', data=json.dumps(ACCESSIBLE_BODY))

		for green in range(LEVEL_BODY['green']):
			green_index = green + 1
			GREEN_BODY = {
			  'parkType': 'green',
			  'name': 'Green' + str(green_index),
			  'emptyFlag': 1
			}
			requests.post(LOCAL_URL + '/api/level/' + str(level_index) + '/spot/', data=json.dumps(GREEN_BODY))

		for general in range(LEVEL_BODY['general']):
			general_index = general + 1
			GENERAL_BODY = {
			  'parkType': 'general',
			  'name': 'General' + str(general_index),
			  'emptyFlag': 1
			}			
			requests.post(LOCAL_URL + '/api/level/' + str(level_index) + '/spot/', data=json.dumps(GENERAL_BODY))

