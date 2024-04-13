from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

spaces = Blueprint('spaces', __name__)


#SELECT *
#FROM Space WHERE IsAvailable = true; -- Viewing availability; 1.2
@spaces.route('/spaces/route1', methods=['GET'])
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



#INSERT INTO Space (SpaceId, BuildingId)
#   VALUES (4, 2); -- Adding space; 3.1


#DELETE FROM Space
#   WHERE SpaceId = 4; -- Removing a space; 3.2


#UPDATE Space
#SET isAvailable = false
#WHERE SpaceId = 3; -- Update a room to be offline; 3.3


#SELECT SpaceId, Space.isAvailable as Available
#FROM Space
#WHERE isAvailable =True; -- View all available rooms; 3.4
@spaces.route('/spaces/route5', methods=['GET'])
def get_avail_spaces():
    cursor = db.get_db().cursor()
    cursor.execute('select SpaceId, Space.isAvailable as Available \
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

