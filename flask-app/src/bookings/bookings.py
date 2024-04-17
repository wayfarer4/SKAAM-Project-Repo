from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

bookings = Blueprint('bookings', __name__)

#in use
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

#in use
@bookings.route('/bookings/booking_in_building', methods=['GET'])
def booking_in_building():
    app_info = request.json
    current_app.logger.info(app_info)
    staff_id = app_info['staff_id']

    query = 'SELECT bo.BookingId FROM BuildingManager bm JOIN Building b ON bm.StaffId = b.StaffId' + ' JOIN Spaces s ON s.BuildingId = b.BuildingId JOIN Booking bo ON bo.SpaceId = s.SpaceId  WHERE bm.StaffId = ' + str(staff_id)
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
@bookings.route('/bookings/cancel', methods=['DELETE'])
def cancel_booking():
    booking_detail_info = request.json
    current_app.logger.info(booking_detail_info)
    bookingId = booking_detail_info['BookingId']

    the_data = request.json
    current_app.logger.info(the_data)

    query = 'DELETE FROM Booking WHERE BookingId = ' + str(bookingId)
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'booking canceled!'



