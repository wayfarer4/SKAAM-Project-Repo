## routes for blueprints

from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

#spaces = Blueprint('spaces', __name__)


## ROUTE 1 FOR SPACES
#SELECT *
#FROM Space WHERE IsAvailable = true; -- Viewing availability; 1.2
# Get all available spaces from db
# @spaces.route('/spaces/route1', methods=['GET'])
def get_avail_spaces():
    cursor = db.get_db().cursor()
    cursor.execute('select * \
                    from customers WHERE IsAvailable = TRUE')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

### ROUTE 1 FOR BOOKING
#UPDATE BookingDetails
#SET CheckedIn = '2024-04-03 03:30:00'
#WHERE BookingId = 4; -- Check in; 1.3

# Add a PUT /Booking route that will update the booking details information
# @booking.route('/booking/route1', methods=['PUT'])
def update_checkIn():
    booking_detail_info = request.json
    current_app.logger.info(booking_detail_info)
    CheckedIn = booking_detail_info['CheckedIn']

    query = 'UPDATE BookingDetails SET CheckedIn = %s where id = %s'
    data = (CheckedIn)
    cursor = db.get_db().cursor()
    r = cursor.execute(query, data)
    db.get_db().commit()
    return 'check in time updated!'



### ROUTE 2 FOR BOOKING
#UPDATE BookingDetails
#SET BookingNameEvent = 'Study Session'
#WHERE BookingId = 4; -- Change Booking Name; 1.4

# Add a PUT /Booking route that will update the booking details information
# @booking.route('/booking/route2', methods=['PUT'])
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
# @booking.route('/booking/route3', methods=['PUT'])
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
#@booking.route('/booking/route4', methods=['POST'])
def cancel_booking():
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    name = the_data['product_name']
    description = the_data['product_description']
    price = the_data['product_price']
    category = the_data['product_category']

    # Constructing the query
    query = 'insert into products (product_name, description, category, list_price) values ("'
    query += name + '", "'
    query += description + '", "'
    query += category + '", '
    query += str(price) + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'


# -----
