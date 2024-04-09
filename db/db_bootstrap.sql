-- This file is to bootstrap a database for the CS3200 project. 

-- Create a new database.  You can change the name later.  You'll
-- need this name in the FLASK API file(s),  the AppSmith 
-- data source creation.
create database occupy_db;

-- Via the Docker Compose file, a special user called webapp will 
-- be created in MySQL. We are going to grant that user 
-- all privilages to the new database we just created. 
-- TODO: If you changed the name of the database above, you need 
-- to change it here too.
grant all privileges on occupy_db.* to 'webapp'@'%';
flush privileges;
#
-- Move into the database we just created.
-- TODO: If you changed the name of the database above, you need to
-- change it here too. 
use occupy_db;

-- Put your DDL 
CREATE TABLE IF NOT EXISTS Professor
(
    StaffId    int PRIMARY KEY,
    Email      VARCHAR(75)     NOT NULL,
    FirstName  VARCHAR(50)     NOT NULL,
    MiddleName VARCHAR(50),
    LastName   VARCHAR(50)     NOT NULL
);

CREATE TABLE IF NOT EXISTS Class
(
    CourseId   int PRIMARY KEY,
    ClassName  VARCHAR(50),
    StaffId    int,
    CONSTRAINT fk01
        FOREIGN KEY (StaffId) REFERENCES Professor (StaffId)
            ON UPDATE cascade ON DELETE restrict
);


CREATE TABLE IF NOT EXISTS ITPerson
(
    StaffId   int PRIMARY KEY,
    PhoneNum  VARCHAR(15),
    UNIQUE INDEX uq_idx_phone_num(PhoneNum)
);

CREATE TABLE IF NOT EXISTS BuildingManager (
    StaffId int PRIMARY KEY,
    Email VARCHAR(75),
    FirstName  VARCHAR(50)     NOT NULL,
    MiddleName VARCHAR(50),
    LastName   VARCHAR(50)     NOT NULL
);

CREATE TABLE IF NOT EXISTS Building (
    BuildingId int PRIMARY KEY,
    isActive BOOLEAN DEFAULT true,
    Floors int,
    BuildingName VARCHAR(50),
    StaffId int,
    CONSTRAINT fk06
        FOREIGN KEY (StaffId) REFERENCES BuildingManager (StaffId)
        ON UPDATE cascade ON DELETE restrict
);


CREATE TABLE IF NOT EXISTS Space
(
    SpaceId   int PRIMARY KEY,
    BuildingId  int,
    IsInAcademicBuilding BOOLEAN DEFAULT true,
    IsAvailable BOOLEAN DEFAULT true,
    CONSTRAINT fk2
        FOREIGN KEY (BuildingId) REFERENCES Building (BuildingId)
        ON UPDATE cascade
);



CREATE TABLE IF NOT EXISTS Classroom (
    ClassroomId int PRIMARY KEY,
    CourseId int,
    StaffId int,
    SpaceId int,
    CONSTRAINT fk03
        FOREIGN KEY (CourseId) REFERENCES Class (CourseId)
        ON UPDATE cascade,
    CONSTRAINT fk04
        FOREIGN KEY (StaffId) REFERENCES ITPerson (StaffId)
        ON UPDATE cascade ON DELETE restrict,
     CONSTRAINT fk05
        FOREIGN KEY (SpaceId) REFERENCES Space (SpaceId)
        ON UPDATE cascade ON DELETE restrict
);


CREATE TABLE IF NOT EXISTS Cleaner (
    CleanerId int PRIMARY KEY,
    Email VARCHAR(75),
    FirstName  VARCHAR(50)     NOT NULL,
    MiddleName VARCHAR(50),
    LastName   VARCHAR(50)     NOT NULL,
    Phone VARCHAR(15),
    UNIQUE INDEX uq_idx_phone(Phone)
);


CREATE TABLE IF NOT EXISTS Incident (
    IncidentId int PRIMARY KEY,
    Type VARCHAR(75),
    IncidentTime DATETIME,
    IncidentName VARCHAR(100),
    CleanerId int,
    CONSTRAINT fk07
        FOREIGN KEY (CleanerId) REFERENCES Cleaner (CleanerId)
        ON UPDATE cascade ON DELETE restrict
);


CREATE TABLE IF NOT EXISTS Student (
    NUId int PRIMARY KEY,
    Email VARCHAR(75),
    FirstName  VARCHAR(50)     NOT NULL,
    MiddleName VARCHAR(50),
    LastName   VARCHAR(50)     NOT NULL,
    isClubLead BOOLEAN DEFAULT false # changed to false -Melissa
);


CREATE TABLE IF NOT EXISTS Booking (
    BookingId int PRIMARY KEY,
    SpaceId int,
    NUId int,
    CONSTRAINT fk08
        FOREIGN KEY (NUId) REFERENCES Student (NUId)
        ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk09
        FOREIGN KEY (SpaceId) REFERENCES Space (SpaceId)
        ON UPDATE cascade ON DELETE restrict
);


CREATE TABLE IF NOT EXISTS BookingDetails (
    BookingId int,
    BookingNameEvent VARCHAR(75),
    PRIMARY KEY (BookingId, BookingNameEvent),
    BookingTime DATETIME NOT NULL,
    CheckedIn DATETIME, # removed NOT NULL so NULL is a default before user checks in -Melissa
    BookingLength TIME NOT NULL, # Added attribute - Melissa
    CONSTRAINT fk10
        FOREIGN KEY (BookingId) REFERENCES Booking (BookingId)
        ON UPDATE cascade ON DELETE cascade # changed to ON DELETE cascade so user can cancel a booking
);


CREATE TABLE IF NOT EXISTS SpaceCleaners (
    SpaceId int,
    CleanerId int,
    PRIMARY KEY (SpaceId, CleanerId),
    CONSTRAINT fk11
        FOREIGN KEY (SpaceId) REFERENCES Space (SpaceId)
        ON UPDATE cascade ON DELETE restrict,
     CONSTRAINT fk12
        FOREIGN KEY (CleanerId) REFERENCES Cleaner (CleanerId)
        ON UPDATE cascade ON DELETE restrict
);

-- Add sample data. 
INSERT INTO fav_colors
  (name, color)
VALUES
  ('dev', 'blue'),
  ('pro', 'yellow'),
  ('junior', 'red');
