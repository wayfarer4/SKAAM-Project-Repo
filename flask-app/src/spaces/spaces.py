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
@spaces.route('/spaces/route2', methods=['POST'])
def add_space():
    the_data = request.json
    current_app.logger.info(the_data)

    SpaceId = the_data['SpaceId']
    BuildingId = the_data['BuildingId']

    query = 'insert into Space (SpaceId, BuildingId)'
    query += str(SpaceId) + '","'
    query += str(BuildingId) + '","'
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return "success!"




#DELETE FROM Space
#   WHERE SpaceId = 4; -- Removing a space; 3.2
@spaces.route('/spaces/route3', methods=['DELETE'])
def delete_space():
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    # Constructing the query
    query = 'DELETE FROM Space WHERE SpaceId = %s'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'space removed!'


#UPDATE Space
#SET isAvailable = false
#WHERE SpaceId = 3; -- Update a room to be offline; 3.3
@spaces.route('/sapces/route4', methods=['PUT'])
def update_space():
    spaces_info = request.json
    current_app.logger.info(spaces_info)
    IsAvailable = spaces_info['IsAvailble']

    query = 'UPDATE Space SET IsAvailable = false WHERE SpaceId = %s'
    data = (IsAvailable)
    cursor = db.get_db().cursor()
    r = cursor.execute(query, data)
    db.get_db().commit()
    return 'room offline'

#SELECT SpaceId, Space.isAvailable as Available
#FROM Space
#WHERE isAvailable =True; -- View all available rooms; 3.4
@spaces.route('/spaces/route5', methods=['GET'])
def get_avail_spaces_conditions():
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

