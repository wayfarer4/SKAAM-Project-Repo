from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

people = Blueprint('people', __name__)

### ROUTE 1 FOR PEOPLE
#UPDATE Space
#SET isAvailable = false
#WHERE SpaceId = 4; -- Book a space; 1.1 Part 1

@people.route('/people/updatetime', methods=['PUT'])
def updateSpace():
    space_info = request.json
    current_app.logger.info(space_info)
    isAvailable= space_info['isAvailable']

    query = 'UPDATE Spaces SET isAvailable = %s where SpaceId = %s'
    data = (isAvailable)
    cursor = db.get_db().cursor()
    r = cursor.execute(query, data)
    db.get_db().commit()
    return 'check in time updated!'


#INSERT INTO Booking(BookingId, SpaceId, NUId)
#VALUES (4, 4, 1001); -- Book a space; 1.1 Part 2
@people.route('/people/book', methods=['POST'])
def book_space():
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    bookingid = the_data['booking_id']
    spaceid = the_data['space_id']
    nuid = the_data['nuid']

    # Constructing the query
    query = 'insert into Bookings (BookingId, SpaceId, NUId) values ("'
    query += str(bookingid) + '", "'
    query += str(spaceid) + '", "'
    query += str(nuid) + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
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
@people.route('/people/viewbooking', methods=['GET'])
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




#SELECT Email
#FROM Professor p JOIN Class c ON p.StaffId = c.StaffId
#JOIN Classroom C2 ON c.CourseId = C2.CourseId
#JOIN Space S ON C2.SpaceId = S.SpaceId
#JOIN Building b ON S.BuildingID = b.BuildingID
#JOIN BuildingManager m ON b.StaffID = m.StaffID
#WHERE p.StaffId = 1; -- Call Building Manager; 2.2
@people.route('/people/callbuildingmanager', methods=['GET'])
def prof_view_building_manager(profId):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT Email FROM Professor p JOIN Class c ON p.StaffId = c.StaffId JOIN Classroom C2 ON c.CourseId = C2.CourseId' 
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
@people.route('/people/reportincident', methods=['GET'])
def prof_view_cleaner(profId):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT Phone FROM Professor p JOIN Class c ON p.StaffId = c.StaffId JOIN Classroom C2 ON c.CourseId = C2.CourseId' 
                   + ' JOIN Spaces S ON C2.SpaceId = S.SpaceId JOIN Space_Cleaners s2 ON S.SpaceId = s2.SpaceId JOIN Cleaner c3 ON s2.CleanerID = c3.CleanerID'
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


#SELECT PhoneNum
#FROM Professor p JOIN Class c ON p.StaffId = c.StaffId
#JOIN Classroom C2 ON c.CourseId = C2.CourseId
#JOIN ITPerson i ON C2.StaffId
#WHERE p.StaffId  = 1; -- Call IT; 2.4
@people.route('/people/callIT', methods=['GET'])
def prof_view_assigned_it():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT PhoneNum FROM Professor p JOIN Class c ON p.StaffId = c.StaffId' 
                   + ' JOIN Classroom C2 ON c.CourseId = C2.CourseId JOIN ITPerson i ON C2.StaffId'
                    + ' WHERE p.StaffId = ' + str(7661382628))
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



