import random
from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

spaces = Blueprint('spaces', __name__)


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

@spaces.route('/spaces/viewbmspaces', methods=['GET'])
def get_bm_spaces():
    the_data = request.json
    current_app.logger.info(the_data)
    staffId = the_data['staff_id']

    cursor = db.get_db().cursor()
    query = 'SELECT * FROM BuildingManager bm JOIN Building b ON bm.StaffId = b.StaffId' + ' JOIN Spaces s ON s.BuildingId = b.BuildingId' + ' WHERE bm.StaffId = ' + str(staffId)
    current_app.logger.info(query)
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


@spaces.route('/spaces/addspace', methods=['POST'])
def add_space():
    the_data = request.json
    current_app.logger.info(the_data)
    buildingId = the_data['BuildingId']
    spaceId = ''.join([str(random.randint(0, 9)) for _ in range(6)])
    
    query = 'INSERT INTO Spaces (SpaceId, BuildingId, IsInAcademicBuilding, IsAvailable) VALUES ( ' + spaceId + ', "' + buildingId + '", true, true)'
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    return 'space added!'

@spaces.route('/spaces/removespace', methods=['DELETE'])
def delete_space():
    
    the_data = request.json
    current_app.logger.info(the_data)
    spaceId = the_data['SpaceId']

    query = 'DELETE FROM Spaces WHERE SpaceId = ' + str(spaceId)
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'space removed!'


@spaces.route('/spaces/updateroom', methods=['PUT'])
def update_space():
    spaces_info = request.json
    current_app.logger.info(spaces_info)
    spaceId = spaces_info['SpaceId']
    isAvailable = spaces_info['IsAvailable']
    isInAcademicBuilding = spaces_info['IsInAcademicBuilding']

    query = 'UPDATE Spaces SET IsAvailable = ' + str(isAvailable) + ' AND IsInAcademicBuilding = ' + str(isInAcademicBuilding) + ' WHERE SpaceId = ' + str(spaceId)
    current_app.logger.info(query)
    cursor = db.get_db().cursor()
    r = cursor.execute(query)
    db.get_db().commit()
    return 'space updated!'

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

@spaces.route('/spaces/get_building_info', methods=['GET'])
def get_building_info():
    the_data = request.json
    current_app.logger.info(the_data)
    staffId = the_data['staff_id']
    cursor = db.get_db().cursor()
    query = 'SELECT * FROM Building b JOIN BuildingManager bm ON b.StaffId = bm.StaffId' + ' WHERE bm.StaffId = ' + str(staffId)
    current_app.logger.info(query)
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

