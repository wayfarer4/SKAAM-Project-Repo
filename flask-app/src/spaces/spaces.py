from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

spaces = Blueprint('spaces', __name__)


#SELECT *
#FROM Space WHERE IsAvailable = true; -- Viewing availability; 1.2
@spaces.route('/spaces/viewavailability', methods=['GET'])
def get_avail_spaces():
    cursor = db.get_db().cursor()
    cursor.execute('select * \
                    from Spaces WHERE IsAvailable = TRUE')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@spaces.route('/spaces/tst', methods=['GET'])
def get_avail_spaces_tst():
    cursor = db.get_db().cursor()
    cursor.execute('select * from Professor')
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
@spaces.route('/spaces/addspace', methods=['POST'])
def add_space():
    the_data = request.json
    current_app.logger.info(the_data)

    SpaceId = the_data['SpaceId']
    BuildingId = the_data['BuildingId']

    query = 'insert into Spaces (SpaceId, BuildingId)'
    query += str(SpaceId) + '","'
    query += str(BuildingId) + '","'
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return "success!"




#DELETE FROM Space
#   WHERE SpaceId = 4; -- Removing a space; 3.2
@spaces.route('/spaces/removespace', methods=['DELETE'])
def delete_space():
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    # Constructing the query
    query = 'DELETE FROM Spaces WHERE SpaceId = %s'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'space removed!'


<<<<<<< HEAD
=======
#UPDATE Space
#SET isAvailable = false
#WHERE SpaceId = 3; -- Update a room to be offline; 3.3
@spaces.route('/sapces/offlineroom', methods=['PUT'])
def update_space():
    spaces_info = request.json
    current_app.logger.info(spaces_info)
    spaceId = spaces_info['SpaceId']

    query = 'UPDATE Spaces SET IsAvailable = false WHERE SpaceId ='
    query += str(spaceId)
    current_app.logger.info(query)
    cursor = db.get_db().cursor()
    r = cursor.execute(query)
    db.get_db().commit()
    return 'room offline'
>>>>>>> 0fb729c13eb4cdd15c8497c8c8208b0a20ebd1df

#SELECT SpaceId, Space.isAvailable as Available
#FROM Space
#WHERE isAvailable =True; -- View all available rooms; 3.4
@spaces.route('/spaces/viewavailable', methods=['GET'])
def get_avail_spaces_conditions():
    cursor = db.get_db().cursor()
    cursor.execute('select SpaceId, Spaces.isAvailable as Available \
                    from Spaces WHERE IsAvailable = TRUE')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

