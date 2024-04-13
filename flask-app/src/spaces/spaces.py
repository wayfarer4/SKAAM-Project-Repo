from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

spaces = Blueprint('spaces', __name__)


#SELECT *
#FROM Space WHERE IsAvailable = true; -- Viewing availability; 1.2




#INSERT INTO Space (SpaceId, BuildingId)
#   VALUES (4, 2); -- Adding space; 3.1


#DELETE FROM Space
#   WHERE SpaceId = 4; -- Removing a space; 3.2


#UPDATE Space
#SET isAvailable = false
#WHERE SpaceId = 3; -- Update a room to be offline; 3.3


#SELECT SpaceId, Space.isAvailable as Available
#FROM Space
#WHERE isAvailable = 1; -- View all available rooms; 3.4


