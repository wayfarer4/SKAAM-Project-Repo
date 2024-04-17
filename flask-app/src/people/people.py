from flask import Blueprint, request, jsonify, make_response, current_app
import json
import random
from src import db

people = Blueprint('people', __name__)

#in use
@people.route('/people/setSpaceUnavailable', methods=['PUT'])
def updateSpace():
    the_data = request.json
    current_app.logger.info(the_data)
    spaceId = the_data['SpaceId']

    query = 'UPDATE Spaces SET isAvailable = 0 where SpaceId = '
    query += str(spaceId)  

    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    r = cursor.execute(query)
    db.get_db().commit()
    return 'check in'

#in use
@people.route('/people/book', methods=['POST'])
def book_space():
    the_data = request.json
    current_app.logger.info(the_data)

    spaceid = the_data['SpaceId']
    nuid = the_data['NUId']
    bookingName = the_data['BookingName']
    bookingLength = the_data['BookingLength']

    booking_id = ''.join([str(random.randint(0, 9)) for _ in range(8)])

    query = 'insert into Booking (BookingId, SpaceId, NUId) values ('
    query += booking_id + ', '
    query += str(spaceid) + ', '
    query += str(nuid) + ')'
    current_app.logger.info(query)

    query2 = 'insert into BookingDetails (BookingId, BookingNameEvent, BookingTime, CheckedIn, BookingLength) values ('
    query2 += booking_id + ', "'
    query2 += bookingName + '", '
    query2 += 'CURRENT_TIMESTAMP, '
    query2 += 'NULL, '
    query2 += str(bookingLength) + ')'
    current_app.logger.info(query2)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    cursor.execute(query2)

    db.get_db().commit()
    
    return 'Success!'
    

#in use
@people.route('/people/getStudents', methods=['GET'])
def get_students():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Student')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

#in use
@people.route('/people/viewstudentbooking', methods=['GET'])
def view_booking_details():
    the_data = request.json
    current_app.logger.info(the_data)
    studentId = the_data['student_id']

    query = 'SELECT * FROM Student s JOIN Booking b on s.NUId = b.NUId JOIN '
    query += 'BookingDetails BD on b.BookingId = BD.BookingId WHERE s.NUId = ' + str(studentId)
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

#in use
@people.route('/people/callbuildingmanager', methods=['GET'])
def prof_view_building_manager():
    the_data = request.json
    current_app.logger.info(the_data)
    profId = the_data['prof_id']

    cursor = db.get_db().cursor()
    cursor.execute('SELECT m.Email, c.ClassName, C2.ClassroomId FROM Professor p JOIN Class c ON p.StaffId = c.StaffId JOIN Classroom C2 ON c.CourseId = C2.CourseId' 
                   + ' JOIN Spaces S ON C2.SpaceId = S.SpaceId JOIN Building b ON S.BuildingID = b.BuildingID'
                    + ' JOIN BuildingManager m ON b.StaffID = m.StaffID'
                    + ' WHERE p.StaffId = ' + str(profId))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

#in use
@people.route('/people/getCleaner', methods=['GET'])
def prof_view_cleaner():
    the_data = request.json
    current_app.logger.info(the_data)
    profId = the_data['prof_id']
    cursor = db.get_db().cursor()
    cursor.execute('SELECT DISTINCT p.FirstName AS profFirstName, c.ClassName, c3.FirstName AS CleanerFirstName, c3.LastName AS CleanerLastName, c3.cleanerId, c3.phone AS PhoneNumber FROM Professor p JOIN Class c ON p.StaffId = c.StaffId JOIN Classroom C2 ON c.CourseId = C2.CourseId' 
                   + ' JOIN Spaces S ON C2.SpaceId = S.SpaceId JOIN SpaceCleaners s2 ON S.SpaceId = s2.SpaceId JOIN Cleaner c3 ON s2.CleanerID = c3.CleanerID'
                    + ' WHERE p.StaffId = ' + profId)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

#in use
@people.route('/people/findassignedclasses', methods=['GET'])
def find_assigned_classes():
    the_data = request.json
    current_app.logger.info(the_data)
    profId = the_data['prof_id']
    cursor = db.get_db().cursor()
    cursor.execute('SELECT ClassName, CourseId FROM Class WHERE StaffId = ' + profId)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

#in use
@people.route('/people/editassignedclasses', methods=['PUT'])
def edit_assigned_classes():
    the_data = request.json
    current_app.logger.info(the_data)
    classId = the_data['CourseId']
    newClassName = the_data['ClassName']
    cursor = db.get_db().cursor()
    query = 'UPDATE Class SET ClassName = "' + newClassName + '" WHERE CourseId = ' + str(classId)
    current_app.logger.info(query)
    cursor.execute(query )
    db.get_db().commit()
    return 'Success!'

#in use
@people.route('/people/reportIncident', methods=['POST'])
def prof_report_incident():
    the_data = request.json
    current_app.logger.info(the_data)
    incidentId = str().join([str(random.randint(0, 9)) for _ in range(8)])
    incidentType = the_data['incident_type']
    incidentTime = "CURRENT_TIMESTAMP"
    incidentName = the_data['incident_name']
    cleanerId = the_data['cleanerId']

    query = 'insert into Incident (IncidentId, IncidentType, IncidentTime, IncidentName, CleanerId) values ('
    query += incidentId + ', "'
    query += incidentType + '", '
    query += incidentTime + ', "'
    query += incidentName + '", '
    query += str(cleanerId) + ')'
    current_app.logger.info(query)
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    return 'Success!'

#in use
@people.route('/people/callIT', methods=['GET'])
def prof_view_assigned_it():
    the_data = request.json
    current_app.logger.info(the_data)
    profId = the_data['prof_id']


    cursor = db.get_db().cursor()
    cursor.execute('SELECT i.StaffId, className, i.PhoneNum, classroomId FROM Professor p JOIN Class c ON p.StaffId = c.StaffId' 
                   + ' JOIN Classroom C2 ON c.CourseId = C2.CourseId JOIN ITPerson i ON C2.StaffId = i.StaffId'
                    + ' WHERE p.StaffId = ' + str(profId))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response




