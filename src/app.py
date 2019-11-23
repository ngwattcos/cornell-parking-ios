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

#Create a level
@app.route('/api/<int:buildingID>/level', methods=['POST'])
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


#Create a spot
@app.route('/api/building/<int:levelID>/spot/', methods=['POST'])
def create_spot(levelID):
	level = Level.query.filter_by(id = levelID).first()
	if not level:
		return json.dumps( {'success': False, 'error':'level not found!' } ), 404
	post_body = json.loads(request.data)
	spot = Spot(
		parkType = post_body.get('parkType', ''),
		emptyFlag = post_body.get('emptyFlag', '')
	)
	level.spots.append(spot)
	db.session.add(spot)
	db.session.commit()
	return json.dumps( {'success': True, 'data': spot.serialize()} ), 200

#get all buildings
@app.route('/api/buildings/')
def get_building():
    buildings = Building.query.all()
    res = {'success': True, 'data': [t.serialize() for t in buildings]}
    return json.dumps(res), 200

#get a spot
@app.route('/api/xxx/<int:spotID>/', methods=['GET'])
def get_a_spot(spotID):
	spot = Spot.query.filter_by(id=spotID).first()
	if not spot:
		return json.dumps( {'success':False, 'error': 'spot not found!' } ) , 404
	return json.dumps( {'success':True, 'data': spot.serialize() } ) , 200

#Delete a spot
@app.route('/api/level/<int:spotID>/', methods=['DELETE'])
def delete_spot(spotID):
	spot = Spot.query.filter_by(id = spotID).first()
	if not spot:
		return json.dumps( {'success': False, 'error':'spot not found!' } ), 404
	db.session.delete(spot)
	db.session.commit()
	return json.dumps( {'success': True, 'data': spot.serialize()} ), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
