import json
import os
from db import db, Course, Assignment, User
from flask import Flask, request

db_filename = "todo.db"
app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///%s' % db_filename
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SQLALCHEMY_ECHO'] = True

db.init_app(app)
with app.app_context():
    db.create_all()


@app.route('/')
def hello():
    return os.environ['GOOGLE_CLIENT_ID'], 200

@app.route('/api/courses/')
def get_courses():
    courses = Course.query.all()
    res = {'success': True, 'data': [t.serialize() for t in courses]}
    return json.dumps(res), 200

@app.route('/api/courses/', methods=['POST'])
def create_course():
    post_body = json.loads(request.data)
    code = post_body.get('code', '')
    name = post_body.get('name', '')
    course = Course(
        code = code,
        name = name
    )
    db.session.add(course)
    db.session.commit()
    return json.dumps({'success': True, 'data': course.serialize()}), 201

@app.route('/api/course/<int:course_id>/')
def get_course(course_id):
    course = Course.query.filter_by(id = course_id).first()
    if not course:
        return json.dumps({'success': False, 'error': 'Course not found!'}), 404
    return json.dumps({'success': True, 'data': course.serialize()}), 200

@app.route('/api/users/', methods=['POST'])
def create_user():
    post_body = json.loads(request.data)
    name = post_body.get('name', '')
    netid = post_body.get('netid', '')
    user = User(
        name = name,
        netid = netid
    )
    db.session.add(user)
    db.session.commit()
    return json.dumps({'success': True, 'data': user.serialize()}), 201

@app.route('/api/user/<int:user_id>/')
def get_user(user_id):
    user = User.query.filter_by(id = user_id).first()
    if not user:
        return json.dumps({'success': False, 'error': 'Course not found!'}), 404
    return json.dumps({'success': True, 'data': user.serialize()}), 200

@app.route('/api/course/<int:course_id>/add/', methods = ['POST'])
def enroll_course(course_id):
    post_body = json.loads(request.data)
    user_type = post_body.get('type', '')
    user_id = post_body.get('user_id', '')
    user = User.query.filter_by(id = user_id).first()
    course = Course.query.filter_by(id = course_id).first()
    if not user:
        return json.dumps({'success': False, 'error': 'Student not found!'}), 404       
    if not course:
        return json.dumps({'success': False, 'error': 'Course not found!'}), 404       
        
    if user_type.equals('student'):
        course.students.append(user)
    elif user_type.equals('instructor'):
        course.instructors.append(user)
    else:
        return json.dumps({'success': False, 'error': 'Wrong user type!'}), 404
    db.session.add(user)
    db.session.commit()
    return json.dumps({'success': True, 'data': course.serialize()}), 201


@app.route('/api/course/<int:course_id>/assignment/', methods=['POST'])
def create_assignment(course_id):
    course = Course.query.filter_by(id = course_id).first()
    if not course:
        return json.dumps({'success': False, 'error': 'Course not found!'}), 404       
    post_body = json.loads(request.data)
    assignment = Assignment (
              title = post_body.get('title', ''),
              due_date = post_body.get('due_date', ''),
              course_id = course_id
            )
    course.assignments.append(assignment)
    db.session.add(assignment)
    db.session.commit()
    return json.dumps({'success': True, 'data': assignment.serialize()}), 201


    
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
