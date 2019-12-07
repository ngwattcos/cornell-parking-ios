import json
from db import db, Building, Level, Spot
from flask import Flask, request
from datetime import datetime

db_filename = "parking.db"
app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///%s' % db_filename # type of db we're using: sqlite or postgres
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SQLALCHEMY_ECHO'] = True

db.init_app(app)

with app.app_context():
	db.create_all() #create all tables for us

@app.route('/') #take in a function
def god():
    buildings = Building.query.all()
    return json.dumps( {'success':True, 'data': [building.serialize() for building in buildings] } ) , 200

#Create a building
@app.route('/api/building/', methods=['POST'])
def create_building():
    post_body = json.loads(request.data)
    shortName = post_body.get('shortName','')
    longName = post_body.get('longName','')
    building = Building(
			shortName = shortName,
			longName = longName
		)
    db.session.add(building)
    db.session.commit()
    return json.dumps( {'success': True, 'data': building.serialize() } ), 200

#Get all buildings
@app.route('/api/buildings/')
def get_buildings():
    buildings = Building.query.all()
    ans = []
    for building in buildings:
        aBuilding = building.serialize()
        buildingInfo = {}
        buildingInfo['id'] = aBuilding['id']
        buildingInfo['longName'] = aBuilding['longName']
        buildingInfo['total'] = 0
        buildingInfo['totalEmpty'] = 0
        for level in aBuilding['levels']:
                buildingInfo['total'] += level['total']
                buildingInfo['totalEmpty'] += level['totalEmpty']
        ans.append(buildingInfo.copy())
    res = {'success': True, 'data': ans}
    return json.dumps(res), 200

#Get a building
@app.route('/api/building/<int:buildingID>/', methods=['GET'])
def get_a_building(buildingID):
    building = Building.query.filter_by(id=buildingID).first()
    if not building:
        return json.dumps( {'success':False, 'error': 'building not found!' } ) , 404
    
    aBuilding = building.serialize()
    ans = {}
    ans['id'] = aBuilding['id']
    ans['longName'] = aBuilding['longName']
    ans['accessible'] = 0
    ans['accessibleEmpty'] = 0
    ans['green'] = 0
    ans['greenEmpty'] = 0
    ans['general'] = 0
    ans['generalEmpty'] = 0
    ans['total'] = 0
    ans['totalEmpty'] = 0
    for level in aBuilding['levels']:
            ans['accessible'] += level['accessible']
            ans['accessibleEmpty'] += level['accessibleEmpty']
            ans['green'] += level['green']
            ans['greenEmpty'] += level['greenEmpty']
            ans['general'] += level['general']
            ans['generalEmpty'] += level['generalEmpty']
            ans['total'] += level['total']
            ans['totalEmpty'] += level['totalEmpty']
        
    return json.dumps( {'success':True, 'data':ans} ) , 200

#Delete a building
@app.route('/api/building/<int:buildingID>/', methods=['DELETE']) # /api/building/ instead of level?
def delete_building(buildingID):
    building = Building.query.filter_by(id = buildingID).first()
    if not building:
        return json.dumps( {'success': False, 'error':'building not found!' } ), 404
    db.session.delete(building)
    db.session.commit()
    return json.dumps( {'success': True, 'data': building.serialize()} ), 200

#Create a level
@app.route('/api/building/<int:buildingID>/level/', methods=['POST'])
def create_level(buildingID):
    building = Building.query.filter_by(id = buildingID).first()
    if not building:
        return json.dumps( {'success': False, 'error':'building not found!' } ), 404
    post_body = json.loads(request.data)
    level = Level(
		levelName = post_body.get('levelName', ''),
		accessible = post_body.get('accessible', ''),
		green = post_body.get('green', ''),
		general = post_body.get('general', '')
	)
    building.levels.append(level)
    db.session.add(level)
    db.session.commit()
    return json.dumps( {'success': True, 'data': level.serialize()} ), 200
    
#Delete a level
@app.route('/api/level/<int:levelID>/', methods=['DELETE'])
def delete_level(levelID):
    level = Level.query.filter_by(id = levelID).first()
    if not level:
        return json.dumps( {'success': False, 'error':'level not found!' } ), 404
    db.session.delete(level)
    db.session.commit()
    return json.dumps( {'success': True, 'data': level.serialize()} ), 200

#Enter building by buildingID and Parking Type, showing empty slotID & floor plan
@app.route('/api/building/<int:buildingID>/parkType/<int:parkTypeInt>/', methods=['GET'])
def enter_building(buildingID, parkTypeInt):
    building = Building.query.filter_by(id=buildingID).first()
    if not building:
        return json.dumps( {'success':False, 'error': 'building not found!' } ) , 404
    aBuilding = building.serialize()
    ans = {}
    levelList = []
    firstFlag = False
    freeSpots = []
    if parkTypeInt == 0:
        parkType = 'accessible'
    elif parkTypeInt == 1:
        parkType = 'green'
    else:
        parkType = 'general'
    parkTypeEmpty = parkType + 'Empty'
    for level in aBuilding['levels']:
        if level[parkTypeEmpty] > 0 or level['generalEmpty'] > 0:
            levelList.append({'Level Name': level['levelName'], 'Level ID': level['id']})
            if not firstFlag:
                spots = level['spots']
                firstFlag = True
                for spot in spots:
                    if spot['parkType'] == parkType and spot['emptyFlag'] == 1:
                        freeSpots.append({'spotid': spot['id'], 'spotName': spot['name']})
                    elif spot['parkType'] == 'general' and spot['emptyFlag'] == 1:
                        freeSpots.append({'spotid': spot['id'], 'spotName': spot['name']})
                        
    if len(freeSpots) == 0:
        return json.dumps( {'success':False, 'error': 'No compatible spots!' } ) , 404
    ans['spotid'] = freeSpots[0]['spotid']
    ans['spotName'] = freeSpots[0]['spotName']
    ans['levelName'] = levelList[0]
    ans['levels'] = levelList
    ans['spots'] = spots
    return json.dumps( {'success':True, 'data': ans } ) , 200

#Enter level by levelID and Parking Type, showing empty slotID on that level
@app.route('/api/level/<int:levelID>/parkType/<int:parkTypeInt>/', methods=['GET'])
def enter_level(levelID, parkTypeInt):
    level = Level.query.filter_by(id=levelID).first()
    if not level:
        return json.dumps( {'success':False, 'error': 'level not found!' } ) , 404
    aLevel = level.serialize()
    ans = {}
    freeSpots = []
    if parkTypeInt == 0:
        parkType = 'accessible'
    elif parkTypeInt == 1:
        parkType = 'green'
    else:
        parkType = 'general'
    parkTypeEmpty = parkType + 'Empty'
    if aLevel[parkTypeEmpty] > 0 or aLevel['generalEmpty'] > 0:
        spots = aLevel['spots']
        for spot in spots:
            if spot['parkType'] == parkType and spot['emptyFlag'] == 1:
                freeSpots.append({'spotid': spot['id'], 'spotName': spot['name']})
            elif spot['parkType'] == 'general' and spot['emptyFlag'] == 1:
                freeSpots.append({'spotid': spot['id'], 'spotName': spot['name']})
                    
    if len(freeSpots) == 0:
        return json.dumps( {'success':False, 'error': 'No compatible spots!' } ) , 404
    ans['spotid'] = freeSpots[0]['spotid']
    ans['spotName'] = freeSpots[0]['spotName']
    ans['spots'] = spots
    return json.dumps( {'success':True, 'data': ans } ) , 200

#Create a spot
@app.route('/api/level/<int:levelID>/spot/', methods=['POST'])
def create_spot(levelID):
	level = Level.query.filter_by(id = levelID).first()
	if not level:
		return json.dumps( {'success': False, 'error':'level not found!' } ), 404
	post_body = json.loads(request.data)
	spot = Spot(
		parkType = post_body.get('parkType', ''),
		emptyFlag = post_body.get('emptyFlag', ''),
        name = post_body.get('name', '')
	)
	level.spots.append(spot)
	db.session.add(spot)
	db.session.commit()
	return json.dumps( {'success': True, 'data': spot.serialize()} ), 200



#get a spot
@app.route('/api/xxx/<int:spotID>/', methods=['GET'])
def get_a_spot(spotID):
	spot = Spot.query.filter_by(id=spotID).first()
	if not spot:
		return json.dumps( {'success':False, 'error': 'spot not found!' } ) , 404
	return json.dumps( {'success':True, 'data': spot.serialize() } ) , 200

#Delete a spot
@app.route('/api/spot/<int:spotID>/', methods=['DELETE'])
def delete_spot(spotID):
	spot = Spot.query.filter_by(id = spotID).first()
	if not spot:
		return json.dumps( {'success': False, 'error':'spot not found!' } ), 404
	db.session.delete(spot)
	db.session.commit()
	return json.dumps( {'success': True, 'data': spot.serialize()} ), 200

#Park car given spot id
@app.route('/api/park/<int:spotID>/', methods=['POST'])
def park_given_spot_id(spotID):
    spot = Spot.query.filter_by(id = spotID).first()
    if not spot:
        return json.dumps( {'success': False, 'error':'spot not found!' } ), 404
    if spot.emptyFlag==0:
        return json.dumps( {'success': False, 'error':'spot already taken!' } ), 404
    
    spot.emptyFlag = 0
    
    spot.start_time = datetime.utcnow()
    
    db.session.commit()
    return json.dumps( {'success': True, 'data': spot.serialize()} ), 201

#Leave car given spot id
@app.route('/api/leave/<int:spotID>/', methods=['POST'])
def leave_given_spot_id(spotID):
    spot = Spot.query.filter_by(id = spotID).first()
    if not spot:
        return json.dumps( {'success': False, 'error':'spot not found!' } ), 404
    if spot.emptyFlag==1:
        return json.dumps( {'success': False, 'error':'Not your spot!' } ), 404
    
    spot.emptyFlag = 1
    
    spot.end_time = datetime.utcnow()
    
    ans = spot.serialize()
    if spot.parkType == 'accessible':
        charge = 0
    else:
        duration = spot.end_time - spot.start_time
        seconds = duration.total_seconds()
        charge =  seconds * 0.003
    ans['charge'] = charge
    
    db.session.commit()
    return json.dumps( {'success': True, 'data': ans} ), 201

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
