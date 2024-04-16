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
@bookings.route('/bookings/updatename', methods=['PUT'])
def update_booking_name():
    booking_detail_info = request.json
    current_app.logger.info(booking_detail_info)
    BookingNameEvent = booking_detail_info['BookingNameEvent']

    query = 'UPDATE BookingDetails SET BookingNameEvent = %s where id = %s'
    data = (BookingNameEvent)
    cursor = db.get_db().cursor()
    r = cursor.execute(query, data)
    db.get_db().commit()
    return 'booking name updated!'

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



