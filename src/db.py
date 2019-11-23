from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

association_table_stu = db.Table('assiciation_stu', db.Model.metadata,
                             db.Column('course_id', db.Integer, db.ForeignKey('course.id')),
                             db.Column('user_id', db.Integer, db.ForeignKey('user.id'))
                             )

association_table_ins = db.Table('assiciation_ins', db.Model.metadata,
                             db.Column('course_id', db.Integer, db.ForeignKey('course.id')),
                             db.Column('user_id', db.Integer, db.ForeignKey('user.id'))
                             )

class Course(db.Model):
    __tablename__ = 'course'
    id = db.Column(db.Integer, primary_key = True)
    code = db.Column(db.String, nullable = False)
    name = db.Column(db.String, nullable = False)
    assignments = db.relationship('Assignment', cascade = 'delete')
    students = db.relationship('User', secondary = association_table_stu, back_populates = 'courses_stu')
    instructors = db.relationship('User', secondary = association_table_ins, back_populates = 'courses_ins')
    
    def __init__(self, **kwargs):
        self.code = kwargs.get('code', '')
        self.name = kwargs.get('name', '')
        self.assignments = []
        self.instructors = []
        self.students = []
        
    def serialize(self):
        return {
                'id': self.id,
                'code': self.code,
                'name': self.name,
                'assignments': [ass.serialize() for ass in self.assignments],
                'instructors': [ins.serialize() for ins in self.instructors],
                'students': [stu.serialize() for stu in self.students]
                }
        
class Assignment(db.Model):
    __tablename__ = 'assignment'
    id = db.Column(db.Integer, primary_key = True)
    title = db.Column(db.String, nullable = False)
    due_date = db.Column(db.Integer, nullable = False)
    course_id = db.Column(db.Integer, db.ForeignKey('course.id'), nullable = False)
    
    def __init__(self, **kwargs):
        self.title = kwargs.get('title', '')
        self.due_date = kwargs.get('due_date', '')
        
    def serialize(self):
        return {
                'id': self.id,
                'title': self.title,
                'due_date': self.due_date,
                }

class User(db.Model):
    __tablename__ = 'user'
    id = db.Column(db.Integer, primary_key = True)
    name = db.Column(db.String, nullable = False)
    netid = db.Column(db.String, nullable = False)
    courses_stu = db.relationship('Course', secondary = association_table_stu, back_populates = 'students')
    courses_ins = db.relationship('Course', secondary = association_table_ins, back_populates = 'instructors')

    
    def __init__(self, **kwargs):
        self.name = kwargs.get('name', '')
        self.netid = kwargs.get('netid', '')
        
    def serialize(self):
        return {
                'id': self.id,
                'name': self.name,
                'netid': self.netid,
                'courses': [stu.serialize() for stu in self.courses_stu] + [ins.serialize() for ins in self.courses_ins]
                }    