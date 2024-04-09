#UPDATE Space
#SET isAvailable = false
#WHERE SpaceId = 4; -- Book a space; 1.1 Part 1


#INSERT INTO Booking(BookingId, SpaceId, NUId)
#VALUES (4, 4, 1001); -- Book a space; 1.1 Part 2


#INSERT INTO BookingDetails(BookingId, BookingNameEvent, BookingTime, CheckedIn, BookingLength)
#VALUES (4, 'Study', '2024-04-03 4:00:00', NULL, '01:00:00'); -- Book a space; 1.1 Part 3





#SELECT BookingNameEvent, CheckedIn, BookingTime
#FROM Professor p JOIN Class c ON p.StaffId = c.StaffId
#JOIN Classroom C2 on c.CourseId = C2.CourseId
#JOIN Space S on C2.SpaceId = S.SpaceId
#JOIN Booking B on S.SpaceId = B.SpaceId
#JOIN BookingDetails BD on B.BookingId = BD.BookingId
#WHERE p.StaffId = 1; -- View professor's own booking details; 2.1


#SELECT Email
#FROM Professor p JOIN Class c ON p.StaffId = c.StaffId
#JOIN Classroom C2 ON c.CourseId = C2.CourseId
#JOIN Space S ON C2.SpaceId = S.SpaceId
#JOIN Building b ON S.BuildingID = b.BuildingID
#JOIN BuildingManager m ON b.StaffID = m.StaffID
#WHERE p.StaffId = 1; -- Call Building Manager; 2.2


#SELECT Phone
#FROM Professor p JOIN Class c ON p.StaffId = c.StaffId
#JOIN Classroom C2 ON c.CourseId = C2.CourseId
#JOIN Space S ON C2.SpaceId = S.SpaceId
#JOIN Space_Cleaners s2 ON S.SpaceId = s2.SpaceId
#JOIN Cleaner c3 ON s2.CleanerID = c3.CleanerID
#WHERE p.StaffId = 1; -- Report an incident; 2.3


#SELECT PhoneNum
#FROM Pro fessor p JOIN Class c ON p.StaffId = c.StaffId
#JOIN Classroom C2 ON c.CourseId = C2.CourseId
#JOIN ITPerson i ON C2.StaffId
#WHERE p.StaffId  = 1; -- Call IT; 2.4


# NOTE: for recurring meetings, I want this to be 
# where someone can select a number of recurring meetings to hold
# and python loops insert statements

#INSERT INTO Booking(BookingId, SpaceId, NUId)
#VALUES (5, 5, 1005); -- Set weekly scheduled meetings; 4.6 Part 1



