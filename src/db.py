# -*- coding: utf-8 -*-
"""
Created on Fri Nov 22 16:41:55 2019

@author: yugua
"""
import json
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import DateTime

db = SQLAlchemy()

class Building(db.Model):
    __tablename__ = 'building'
    id = db.Column(db.Integer, primary_key = True)
    shortName = db.Column(db.String, nullable = False)
    longName = db.Column(db.String, nullable = False)
    levels = db.relationship('Level', cascade = 'delete')
    
    def __init__(self, **kwargs):
        self.shortName = kwargs.get('shortName', '')
        self.longName = kwargs.get('longName', '')
        self.levels = []
        
    def serialize(self):
        return {
                'id': self.id,
                'shortName': self.shortName,
                'longName': self.longName,
                'levels': [level.serialize() for level in self.levels]
                }
 
class Level(db.Model):
    __tablename__ = 'level'
    id = db.Column(db.Integer, primary_key = True)
    levelName = db.Column(db.String, nullable = False)
    accessible = db.Column(db.Integer, nullable = False)
    green = db.Column(db.Integer, nullable = False)
    general = db.Column(db.Integer, nullable = False)
    building = db.Column(db.Integer, db.ForeignKey('building.id'), nullable = False)
    spots = db.relationship('Spot', cascade = 'delete')
        
    def __init__(self, **kwargs):
        self.levelName = kwargs.get('levelName', '')
        self.accessible = kwargs.get('accessible', '')
        self.green = kwargs.get('green', '')
        self.general = kwargs.get('general', '')
        self.spots = []        

    def serialize(self):
        count = 0
        countAcc = 0
        countGre = 0
        countGen = 0
        for spot in self.spots:
            aspot = spot.serialize()
            if aspot['emptyFlag'] == 1:
                count += 1                
                if aspot['parkType'] == 'accessible':
                    countAcc += 1
                elif aspot['parkType'] == 'green':
                    countGre += 1
                else:
                    countGen += 1
                                
        return {
                'id': self.id,
                'levelName': self.levelName,
                'green': self.green,
                'greenEmpty': countGre,
                'general': self.general,
                'generalEmpty': countGen,
                'accessible': self.accessible,
                'accessibleEmpty': countAcc,
                'total': self.general + self.green + self.accessible,
                'totalEmpty': count,
                'spots': [spot.serialize() for spot in self.spots]
                }

class Spot(db.Model):
    __tablename__ = 'spot'
    id = db.Column(db.Integer, primary_key = True)    
    name = db.Column(db.String, nullable = False)
    parkType = db.Column(db.String, nullable = False)
    emptyFlag = db.Column(db.Integer, nullable = False)
    level_id = db.Column(db.Integer, db.ForeignKey('level.id'), nullable = False)
    start_time = db.Column(db.DateTime, nullable = True)
    end_time = db.Column(db.DateTime, nullable = True)

    def __init__(self, **kwargs):
        self.name = kwargs.get('name', '')
        self.parkType = kwargs.get('parkType', '')
        self.emptyFlag = kwargs.get('emptyFlag', '')

    def serialize(self):
        starttime = {}
        starttime['stringTime'] = self.start_time
        endtime = {}
        endtime['endTime'] = self.end_time
        startTimeStr = json.dumps(starttime, indent=4, sort_keys=True, default=str)
        startTimeStr = startTimeStr[21:47]
        endTimeStr = json.dumps(endtime, indent=4, sort_keys=True, default=str)
        endTimeStr = endTimeStr[18:44]
        return {
                'id': self.id,
                'parkType': self.parkType,
                'emptyFlag': self.emptyFlag,        
                'name': self.name,
                'startTime': startTimeStr,
                'endTime': endTimeStr
                }