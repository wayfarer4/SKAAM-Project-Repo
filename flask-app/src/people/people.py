from flask import Blueprint, request, jsonify, make_response, current_app
import json
import random
from src import db

people = Blueprint('people', __name__)

### ROUTE 1 FOR PEOPLE
#UPDATE Space
#SET isAvailable = false
#WHERE SpaceId = 4; -- Book a space; 1.1 Part 1

@people.route('/people/updatetime', methods=['PUT'])
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


#INSERT INTO Booking(BookingId, SpaceId, NUId)
#VALUES (4, 4, 1001); -- Book a space; 1.1 Part 2
@people.route('/people/book', methods=['POST'])
def book_space():
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    #bookingid = the_data['booking_id']
    spaceid = the_data['SpaceId']
    nuid = the_data['NUId']
    bookingName = the_data['BookingName']
    bookingLength = the_data['BookingLength']

    booking_id = ''.join([str(random.randint(0, 9)) for _ in range(8)])

    # Constructing the query
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


    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    cursor.execute(query2)

    db.get_db().commit()
    
    return 'Success!'
    
    


#INSERT INTO BookingDetails(BookingId, BookingNameEvent, BookingTime, CheckedIn, BookingLength)
#VALUES (4, 'Study', '2024-04-03 4:00:00', NULL, '01:00:00'); -- Book a space; 1.1 Part 3
@people.route('/people/bookingdetails', methods=['POST'])
def book_space_details():
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    bookingid = the_data['booking_id']
    bookingName = the_data['booking_name_event']
    bookingTime = the_data['nuid']
    checkedin = the_data['checked_in']
    bookingLength = the_data['booking_length']

    # Constructing the query
    query = 'insert into BookingsDetails (BookingId, BookingNameEvent, BookingTime, CheckedIn, BookingLength) values ("'
    query += str(bookingid) + '", "'
    query += bookingName + '", "'
    query += str(bookingTime) + '", "'
    query += str(checkedin) + '", "'
    query += str(bookingLength) + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'
    

#SELECT BookingNameEvent, CheckedIn, BookingTime
#FROM Professor p JOIN Class c ON p.StaffId = c.StaffId
#JOIN Classroom C2 on c.CourseId = C2.CourseId
#JOIN Space S on C2.SpaceId = S.SpaceId
#JOIN Booking B on S.SpaceId = B.SpaceId
#JOIN BookingDetails BD on B.BookingId = BD.BookingId
#WHERE p.StaffId = 1; -- View professor's own booking details; 2.1
@people.route('/people/viewprofbooking', methods=['GET'])
def prof_view_booking_details():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT BookingNameEvent, CheckedIn, BookingTime FROM Professor p JOIN Class c ON' 
                   + ' p.StaffId = c.StaffId JOIN Classroom C2 on c.CourseId = C2.CourseId JOIN Spaces S'
                    + ' on C2.SpaceId = S.SpaceId JOIN Booking B on S.SpaceId = B.SpaceId JOIN '
                    + 'BookingDetails BD on B.BookingId = BD.BookingId WHERE p.StaffId = ' + str(2958467899))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

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

#SELECT Email
#FROM Professor p JOIN Class c ON p.StaffId = c.StaffId
#JOIN Classroom C2 ON c.CourseId = C2.CourseId
#JOIN Space S ON C2.SpaceId = S.SpaceId
#JOIN Building b ON S.BuildingID = b.BuildingID
#JOIN BuildingManager m ON b.StaffID = m.StaffID
#WHERE p.StaffId = 1; -- Call Building Manager; 2.2
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

#SELECT Phone
#FROM Professor p JOIN Class c ON p.StaffId = c.StaffId
#JOIN Classroom C2 ON c.CourseId = C2.CourseId
#JOIN Space S ON C2.SpaceId = S.SpaceId
#JOIN Space_Cleaners s2 ON S.SpaceId = s2.SpaceId
#JOIN Cleaner c3 ON s2.CleanerID = c3.CleanerID
#WHERE p.StaffId = 1; -- Report an incident; 2.3
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

#SELECT PhoneNum
#FROM Professor p JOIN Class c ON p.StaffId = c.StaffId
#JOIN Classroom C2 ON c.CourseId = C2.CourseId
#JOIN ITPerson i ON C2.StaffId
#WHERE p.StaffId  = 1; -- Call IT; 2.4
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


# NOTE: for recurring meetings, I want this to be 
# where someone can select a number of recurring meetings to hold
# and python loops insert statements

#INSERT INTO Booking(BookingId, SpaceId, NUId)
#VALUES (5, 5, 1005); -- Set weekly scheduled meetings; 4.6 Part 1



