import json
from db import db, Building, Level, Spot
from flask import Flask, request

db_filename = "parking.db"
app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///%s' % db_filename # type of db we're using: sqlite or postgres
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SQLALCHEMY_ECHO'] = True

db.init_app(app)

with app.app_context():
	db.create_all() #create all tables for us

@app.route('/') #take in a function

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
    # res = {'success': True, 'data': building.}
    # return json.dumps(res), 200
    return json.dumps( {'success':True, 'data': building.serialize() } ) , 200

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
# =============================================================================
#     return json.dumps( {'success':True, 'data': building.serialize() } ) , 200
# =============================================================================

#Delete a building
@app.route('/api/level/<int:buildingID>/', methods=['DELETE'])
def delete_building(spotID):
    building = Building.query.filter_by(id = spotID).first()
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
    spotAns = {}
    spotSAns = []
    if parkTypeInt == 0:
        parkType = 'accessible'
    elif parkTypeInt == 1:
        parkType = 'green'
    else:
        parkType = 'general'
    parkTypeEmpty = parkType + 'Empty'
    for level in aBuilding['levels']:
        if level[parkTypeEmpty] > 0:
            levelList.append({'Level Name': level['levelName'], 'Level ID': level['id']})
            if not firstFlag:
                spots = level['spots']
                firstFlag = True
                for spot in spots:
                    spotSAns.append(spot)
                    if spot['parkType'] == parkType and spot['emptyFlag'] == 1:
                        spotAns['id'] = spot['id']
                        spotAns['name'] = spot['name']
    if len(spotAns) == 0:
        return json.dumps( {'success':False, 'error': 'building is full!' } ) , 404
    ans['spotid'] = spotAns['id']
    ans['spotName'] = spotAns['name']
    ans['levelName'] = levelList[0]
    ans['levels'] = levelList
    ans['spots'] = spotSAns
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
        name = post_body.get('name', ''),
        date_time = post_body.get('date_time', '')
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
    db.session.commit()
    return json.dumps( {'success': True, 'data': spot.serialize()} ), 201

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
