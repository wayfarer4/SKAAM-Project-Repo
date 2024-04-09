#UPDATE BookingDetails
#SET CheckedIn = '2024-04-03 03:30:00'
#WHERE BookingId = 4; -- Check in; 1.3


#UPDATE BookingDetails
#SET BookingNameEvent = 'Study Session'
#WHERE BookingId = 4; -- Change Booking Name; 1.4


#UPDATE BookingDetails
#SET BookingLength = '01:30:00'
#WHERE BookingId = 4; -- Extend the booking; 1.5


#DELETE FROM BookingDetails
#WHERE BookingId = 1; -- Cancel booking; 1.6
