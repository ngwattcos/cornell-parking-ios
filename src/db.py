# -*- coding: utf-8 -*-
"""
Created on Fri Nov 22 16:41:55 2019

@author: yugua
"""

from flask_sqlalchemy import SQLAlchemy

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
        return {
                'id': self.id,
                'levelName': self.levelName,
                'green': self.green,
                'general': self.general,
                'accessible': self.accessible,
                'total': self.general + self.green + self.accessible,
                'spots': [spot.serialize() for spot in self.spots]
                }
        
class Spot(db.Model):
    __tablename__ = 'spot'
    id = db.Column(db.Integer, primary_key = True)
    parkType = db.Column(db.String, nullable = False)
    emptyFlag = db.Column(db.Integer, nullable = False)
    level_id = db.Column(db.Integer, db.ForeignKey('level.id'), nullable = False)
    
    def __init__(self, **kwargs):
        self.parkType = kwargs.get('parkType', '')
        self.emptyFlag = kwargs.get('emptyFlag', '')
        
    def serialize(self):
        return {
                'id': self.id,
                'parkType': self.parkType,
                'emptyFlag': self.emptyFlag
                }