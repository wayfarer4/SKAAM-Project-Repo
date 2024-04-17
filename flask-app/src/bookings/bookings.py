from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

bookings = Blueprint('bookings', __name__)

### ROUTE 1 FOR BOOKING
#UPDATE BookingDetails
#SET CheckedIn = '2024-04-03 03:30:00'
#WHERE BookingId = 4; -- Check in; 1.3

# Add a PUT /Booking route that will update the booking details information
@bookings.route('/bookings/checkin', methods=['PUT'])
def update_checkIn():
    booking_detail_info = request.json
    current_app.logger.info(booking_detail_info)
    bookingId = booking_detail_info['BookingId']

    query = 'UPDATE BookingDetails SET CheckedIn = CURRENT_TIMESTAMP WHERE BookingId = '
    query += str(bookingId)
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    r = cursor.execute(query)
    db.get_db().commit()
    return 'check in time updated!'


### ROUTE 2 FOR BOOKING
#UPDATE BookingDetails
#SET BookingNameEvent = 'Study Session'
#WHERE BookingId = 4; -- Change Booking Name; 1.4

# Add a PUT /Booking route that will update the booking details information
@bookings.route('/bookings/booking_in_building', methods=['GET'])
def booking_in_building():
    booking_detail_info = request.json
    current_app.logger.info(booking_detail_info)
    staff_id = booking_detail_info['staff_id']

    query = 'SELECT BookingNameEvent, BookingId FROM BuildingManager bm JOIN Building b on bm.StaffId = b.StaffId' 
    + ' JOIN Spaces s on s.BuildingId = b.BuildingId JOIN Booking bo on bo.SpaceId = s.SpaceId JOIN BookingDetails bd'
    + ' ON bd.BookingId = bo.BookingId WHERE bm.StaffId ='
    + str(staff_id)
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

### ROUTE 3 FOR BOOKING
#UPDATE BookingDetails
#SET BookingLength = '01:30:00'
#WHERE BookingId = 4; -- Extend the booking; 1.5

# Add a PUT /Booking route that will update the booking details information
@bookings.route('/bookings/updatelength', methods=['PUT'])
def update_booking_length():
    booking_detail_info = request.json
    current_app.logger.info(booking_detail_info)
    BookingLength = booking_detail_info['BookingLength']

    query = 'UPDATE BookingDetails SET BookingLength = %s where id = %s'
    data = (BookingLength)
    cursor = db.get_db().cursor()
    r = cursor.execute(query, data)
    db.get_db().commit()
    return 'booking length updated!'


### ROUTE 4 FOR BOOKING
# DELETE FROM BookingDetails
# WHERE BookingId = 1; -- Cancel booking; 1.6
@bookings.route('/bookings/cancel', methods=['DELETE'])
def cancel_booking():
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    # Constructing the query
    query = 'DELETE FROM BookingDetails WHERE BookingId = %s'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'booking canceled!'



