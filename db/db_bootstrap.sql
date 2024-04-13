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
    middleName VARCHAR(50),
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
INSERT INTO Professor(StaffId,Email,FirstName,MiddleName,LastName) VALUES
 (8924663895,'lganing0@dell.com','Lida','Lynn','Ganing')
,(1563157152,'psaill1@dropbox.com','Rawley','Pascal','Saill')
,(7661382628,'mkelberer2@altervista.org','Harriott','Maggy','Kelberer')
,(2409516211,'mgoldstone3@instagram.com','Cris','Miquela','Goldstone')
,(9966170154,'fspataro4@salon.com','Wendy','Fair','Spataro')
,(9678000784,'ominghi5@vk.com','Brooks','Oren','Minghi')
,(6497399429,'lcorbert6@list-manage.com','Terrye','Laurent','Corbert')
,(1940790387,'fmatuszyk7@meetup.com','Roddy','Francois','Matuszyk')
,(1190007312,'tburker8@who.int','Randy','Tannie','Burker')
,(7801123107,'wciccarelli9@cnbc.com','Willamina','Winston','Ciccarelli')
,(5903776388,'wmumma@deviantart.com','Carmita','Wilmette','Mumm')
,(5739328527,'mpearmainb@pcworld.com','Charmaine','Meriel','Pearmain')
,(4106164833,'mheritegec@theatlantic.com','Deedee','Maryl','Heritege')
,(3261115165,'nbaudinsd@fastcompany.com','Foster','Northrop','Baudins')
,(2958467899,'pverdeye@twitpic.com','Briggs','Phebe','Verdey')
,(2614078298,'hpimlettf@earthlink.net','Bobbie','Horten','Pimlett')
,(7283517324,'gdobeyg@fc2.com','Joyann','Gianni','Dobey')
,(7121802848,'csollnerh@ebay.com','Sergent','Cyril','Sollner')
,(7351586225,'jwallentini@tinypic.com','Lyman','Jens','Wallentin')
,(3117582983,'mkinnockj@house.gov','Wylie','Maible','Kinnock')
,(6934997948,'dyemmk@vinaora.com','Griffin','Drugi','Yemm')
,(6385237427,'mwagerl@aboutads.info','Letti','Melloney','Wager')
,(7288235270,'cslavinm@mozilla.org','Howie','Cesar','Slavin')
,(2035381703,'lcorleyn@china.com.cn','Giacobo','Loralie','Corley')
,(4920366299,'skamallo@acquirethisname.com','Kristo','Stevena','Kamall')
,(6934213106,'aswyerp@prweb.com','Emalia','Antonia','Swyer')
,(0864654456,'rblindtq@linkedin.com','Bryn','Raleigh','Blindt')
,(5527432916,'lstepneyr@pinterest.com','Willi','Leighton','Stepney')
,(7795263895,'cforms@google.it','Chery','Clair','Form')
,(2866035003,'bagettt@edublogs.org','Wendeline','Berthe','Agett')
,(0301903182,'mcluttonu@webmd.com','Frazer','Merilee','Clutton')
,(3933230837,'ehowgillv@pinterest.com','Lynnet','Edna','Howgill')
,(9211260868,'nmacaulayw@youtu.be','Laurens','Normy','MacAulay')
,(1171095333,'kelletonx@nydailynews.com','Ax','Kerby','Elleton')
,(6465507579,'fkingmany@cnbc.com','Kaye','Francklin','Kingman')
,(7848961249,'gbillinghamz@cam.ac.uk','Fairleigh','Gertrudis','Billingham')
,(3606008813,'bdressel10@zimbio.com','Sanford','Benny','Dressel')
,(7434670614,'hcabral11@howstuffworks.com','Juli','Hilarius','Cabral')
,(1710477628,'babramino12@dropbox.com','Viviana','Benjie','Abramino')
,(3666357415,'smorsom13@blog.com','Meredithe','Stefano','Morsom')
,(8484028275,'koffner14@zdnet.com','Howard','Karlis','Offner')
,(6832199414,'brockwill15@github.io','Carmine','Bartholomew','Rockwill')
,(6107720596,'fhaskur16@nbcnews.com','Kennie','Frederica','Haskur')
,(8399545686,'mbonde17@adobe.com','Emelia','Maurita','Bonde')
,(2722352044,'kbillington18@google.nl','Megan','Kelvin','Billington')
,(4424215288,'liveson19@com.com','Say','Lutero','Iveson')
,(2552388485,'mzavittieri1a@msu.edu','Thaddus','Mohandis','Zavittieri')
,(9995721937,'eflewett1b@youtu.be','Lou','Eunice','Flewett')
,(0288563638,'qhouldin1c@bandcamp.com','Cherri','Quentin','Houldin')
,(9547757555,'cczadla1d@fc2.com','Maggi','Cybil','Czadla')
,(9719654333,'dhay1e@about.me','Marys','Daveen','Hay')
,(2851158546,'sdan1f@google.co.jp','Albie','Shep','Dan')
,(9236017045,'msuckling1g@sciencedaily.com','Lombard','Micki','Suckling')
,(2360489623,'ckondratyuk1h@altervista.org','Pepito','Coraline','Kondratyuk')
,(5174679194,'plloyds1i@51.la','Vincenty','Phebe','Lloyds')
,(4285145626,'smarin1j@comcast.net','Marnie','Salli','Marin')
,(8375959987,'alegrand1k@shareasale.com','Thornton','Arden','Legrand')
,(1823222676,'dsolano1l@twitpic.com','Nikola','Diego','Solano')
,(6486892714,'fspragg1m@marketwatch.com','Gabriel','Fielding','Spragg')
,(3696696862,'hwink1n@theglobeandmail.com','Francoise','Harmonie','Wink');

INSERT INTO Student(NUId,FirstName,LastName,Email,MiddleName,isClubLead) VALUES
 (0328897256,'Doretta','Duinbleton','fduinbleton0@ed.gov','Farley','true')
,(3938493038,'Annaliese','Sainsbury','hsainsbury1@china.com.cn','Helaina','false')
,(3077631962,'Murray','Landsborough','mlandsborough2@ifeng.com','Marlo','false')
,(2381093613,'Stella','Lucks','klucks3@shop-pro.jp','Kaleb','false')
,(7477093937,'Thoma','Ozanne','aozanne4@cornell.edu','Aleece','false')
,(9163289342,'Rriocard','Bachmann','abachmann5@simplemachines.org','Andonis','true')
,(3422740406,'Oralle','Tottie','etottie6@dedecms.com','Egan','false')
,(6703357471,'Howie','Kirtlan','mkirtlan7@bloglines.com','Merry','true')
,(5998501098,'Gretal','Johnston','fjohnston8@bloglovin.com','Faythe','true')
,(3019939291,'Gipsy','Mulrenan','cmulrenan9@cnn.com','Cassondra','true')
,(8380369068,'Syd','Elldred','ielldreda@ovh.net','Irina','true')
,(2633546315,'Pooh','Butterwick','sbutterwickb@mac.com','Sascha','true')
,(0150163525,'Arlyn','Rubega','crubegac@amazonaws.com','Corny','true')
,(7794824869,'Lindsay','Battyll','dbattylld@joomla.org','Desmund','true')
,(0884024261,'Henrietta','Assante','sassantee@gnu.org','Stacie','true')
,(8655206326,'Guntar','Ranscomb','mranscombf@ehow.com','Mackenzie','false')
,(8953645220,'Salvatore','Gabbetis','lgabbetisg@theatlantic.com','Lanny','true')
,(9019075179,'Karlens','Benedettini','kbenedettinih@google.co.uk','Kenn','false')
,(5435712122,'Kevin','Lavelle','elavellei@privacy.gov.au','Ellswerth','true')
,(2636354654,'Upton','Munroe','lmunroej@clickbank.net','Lizzy','true')
,(6329000980,'Burgess','Stearndale','bstearndalek@networkadvertising.org','Benyamin','true')
,(8936937685,'Malory','Plume','fplumel@pbs.org','Florian','true')
,(0843910968,'Karin','Testro','itestrom@rambler.ru','Inge','false')
,(1613682492,'Jacquie','Jedrzaszkiewicz','ljedrzaszkiewiczn@businesswire.com','Lorettalorna','true')
,(9261669654,'Jamaal','Rutty','lruttyo@fema.gov','Linn','true')
,(6276374857,'Nicolis','Thonger','dthongerp@fema.gov','Dorolice','false')
,(6491913783,'Ludwig','Yoseloff','dyoseloffq@tinyurl.com','Demott','false')
,(2104658934,'Thom','Jumont','tjumontr@list-manage.com','Tessie','true')
,(0291645003,'Robinson','Read','areads@blogspot.com','Artair','true')
,(2889118665,'Bailey','Coggeshall','bcoggeshallt@irs.gov','Brita','false')
,(0372091849,'Brandea','Crilley','kcrilleyu@mapquest.com','Kane','true')
,(5107080669,'Karon','Emeline','aemelinev@tmall.com','Avictor','false')
,(5185352523,'Rutherford','McTavy','vmctavyw@tripadvisor.com','Velma','true')
,(7557529294,'Bear','Somerled','ssomerledx@stumbleupon.com','Stu','false')
,(0201287927,'Terese','Stabler','establery@godaddy.com','Eziechiele','false')
,(1496882490,'Rafe','Beniesh','rbenieshz@odnoklassniki.ru','Ryley','false')
,(9714339243,'Desmond','Sherr','esherr10@mediafire.com','Ethelda','false')
,(8056642595,'Kikelia','Derisley','cderisley11@seesaa.net','Christan','true')
,(8295190873,'Viva','Semrad','jsemrad12@go.com','Joann','false')
,(7335626277,'Adamo','Saynor','dsaynor13@skype.com','Donnie','true')
,(2834316295,'Gianina','Irlam','cirlam14@skyrock.com','Conan','false')
,(5310155716,'Lesley','Hurch','lhurch15@webnode.com','Leshia','false')
,(0340867841,'Evan','McElwee','pmcelwee16@angelfire.com','Pippa','false')
,(5618837692,'Janaye','Ockwell','jockwell17@nydailynews.com','Joice','true')
,(6595945649,'Kristoforo','Holborn','hholborn18@dmoz.org','Huntington','false')
,(7583636094,'Clarke','Petrovykh','gpetrovykh19@un.org','Genni','true')
,(3761481284,'Dollie','Bannester','abannester1a@drupal.org','Ally','false')
,(2191535879,'Cordell','Crockley','hcrockley1b@google.cn','Hill','false')
,(3461102660,'Gusty','Ferneley','aferneley1c@usda.gov','Alvinia','true')
,(6951987068,'Kimberley','Antonellini','jantonellini1d@histats.com','Johna','false')
,(3408108668,'Charla','Postians','bpostians1e@myspace.com','Benni','true')
,(8719407157,'Chaddie','Ravilious','bravilious1f@loc.gov','Benn','false')
,(7585280572,'Chalmers','Luff','jluff1g@sciencedaily.com','Jourdain','true')
,(8010510718,'Arnuad','Roddick','broddick1h@skyrock.com','Becki','true')
,(8889953519,'Sigmund','Palfree','lpalfree1i@noaa.gov','Lana','false')
,(4290280889,'Rogerio','Creelman','wcreelman1j@tamu.edu','Witty','false')
,(0886513081,'Anselma','Romayn','kromayn1k@house.gov','Ky','false')
,(6175026330,'Antoinette','Duff','lduff1l@senate.gov','Lorenza','true')
,(1644210320,'Far','Gerran','cgerran1m@flickr.com','Carlin','false')
,(4312079587,'Lutero','Rome','drome1n@biglobe.ne.jp','Delcina','false');

INSERT INTO BuildingManager(StaffId,LastName,Email,FirstName,MiddleName) VALUES
 (6262446117,'Mudle','mmudle0@japanpost.jp','Burr','Mahala')
,(0961680881,'Wink','jwink1@comcast.net','Locke','James')
,(4048493523,'Dannett','hdannett2@miibeian.gov.cn','Eugenio','Hogan')
,(1770515801,'Lippiello','slippiello3@bloglovin.com','Rosetta','Sallyann')
,(0888522665,'Beiderbecke','mbeiderbecke4@archive.org','Clemmie','Meagan')
,(9528742769,'Coughlin','fcoughlin5@narod.ru','Gabrila','Fransisco')
,(9752415539,'Bilsland','lbilsland6@aboutads.info','Yetty','Lelia')
,(9602497203,'Burren','tburren7@goodreads.com','Arabele','Tristam')
,(4804001123,'Shipsey','cshipsey8@deliciousdays.com','Gabi','Colene')
,(2177364418,'Mirfield','cmirfield9@latimes.com','Evaleen','Cindra')
,(0032418175,'Soldner','ssoldnera@facebook.com','Sigmund','Seamus')
,(7220851766,'Bunt','mbuntb@cloudflare.com','Neal','Maggee')
,(4898769306,'Shelly','gshellyc@wix.com','Robyn','Gasper')
,(3872113135,'Hallad','phalladd@pen.io','Murray','Patrica')
,(3807594531,'Byneth','gbynethe@1688.com','Ward','Gertie')
,(0197977758,'Whitticks','bwhitticksf@youtube.com','Cathyleen','Brandy')
,(2681839386,'Magovern','smagoverng@livejournal.com','Bryana','Sella')
,(2582423823,'Takle','etakleh@ebay.com','Heida','Everard')
,(9161870218,'Huckerby','mhuckerbyi@geocities.com','Jehanna','Maryrose')
,(3426593955,'Gerson','dgersonj@google.com.hk','Bobbe','Donal')
,(2627293729,'Knoles','gknolesk@hexun.com','Eduard','Gabby')
,(9516906753,'Simukov','msimukovl@microsoft.com','Fonz','Maureene')
,(9964302681,'Mazin','mmazinm@mozilla.com','Almira','Milicent')
,(1235902013,'Sherborne','rsherbornen@hostgator.com','Ema','Robby')
,(1089236115,'Lebourn','clebourno@craigslist.org','Reggy','Christie')
,(8076214033,'Couser','acouserp@unc.edu','Hermina','Ardeen')
,(7164255652,'Taffe','ktaffeq@yahoo.com','Dani','Kelvin')
,(6399239702,'Kennington','ckenningtonr@jiathis.com','Vicky','Casie')
,(0468979301,'Di Nisco','kdiniscos@123-reg.co.uk','Andria','Karen')
,(7138992688,'Guerrier','uguerriert@marketwatch.com','Wenda','Urbano')
,(0108046982,'Championnet','lchampionnetu@imgur.com','Darelle','Lambert')
,(2869359691,'Bachanski','jbachanskiv@1und1.de','Gill','Job')
,(0453744362,'Creavan','wcreavanw@csmonitor.com','Constantina','Windham')
,(6301275896,'Terram','bterramx@vk.com','Darell','Beatrix')
,(9923973581,'Tinham','ntinhamy@over-blog.com','Merry','Nickie')
,(5840972223,'Osburn','tosburnz@europa.eu','Arabel','Tim')
,(6391857520,'Brabin','mbrabin10@furl.net','Noe','Maire')
,(3309626016,'Catlette','lcatlette11@pinterest.com','Almeda','Lavinia')
,(5423339715,'Linn','alinn12@addthis.com','Etheline','Adelle')
,(3960405278,'Viccars','bviccars13@bigcartel.com','Ikey','Bettine')
,(3987591250,'Swanson','cswanson14@nsw.gov.au','Yolanthe','Cecile')
,(9958486083,'Dundendale','sdundendale15@gmpg.org','Ivette','Stinky')
,(9334177217,'Daber','cdaber16@discuz.net','Bibbye','Charisse')
,(5144394752,'Lowther','jlowther17@kickstarter.com','Fanechka','Jeno')
,(7223137339,'Schroter','sschroter18@tinyurl.com','Kym','Silvain')
,(8056555307,'Collar','hcollar19@auda.org.au','Glyn','Hastings')
,(4501885939,'Roach','rroach1a@redcross.org','Veriee','Robinetta')
,(1009517651,'Reilly','creilly1b@time.com','Tyler','Clifford')
,(3666363032,'Throssell','mthrossell1c@epa.gov','Hector','Magdalen')
,(3905940469,'Pressey','hpressey1d@squidoo.com','Jordan','Hobie')
,(6753092536,'Jeppe','wjeppe1e@imageshack.us','Jolie','Wayne')
,(1297745159,'Tichner','jtichner1f@loc.gov','Cam','Jecho')
,(0742251268,'Regglar','bregglar1g@vinaora.com','Maddy','Beth')
,(9153584635,'Dymock','adymock1h@archive.org','Goldi','Ara')
,(9753683227,'Leyfield','aleyfield1i@webeden.co.uk','Gretchen','Abra')
,(4710478260,'Brognot','jbrognot1j@flickr.com','Patricia','Jeddy')
,(5586223791,'Keijser','ckeijser1k@mozilla.org','Mervin','Cchaddie')
,(7948607773,'Cruz','dcruz1l@oracle.com','Inna','Derwin')
,(4061148869,'Harnott','charnott1m@ask.com','Garrett','Cathyleen')
,(4098889943,'Gonet','pgonet1n@networkadvertising.org','Kiel','Prudy');

INSERT INTO Class(CourseId,ClassName,StaffId) VALUES
 (44563,'Introduction to Biology',4920366299)
,(0,'English Literature',6934997948)
,(37,'Introduction to Computer Science',1171095333)
,(46,'History of Art',2958467899)
,(4,'Algebra I',9719654333)
,(60,'Introduction to Psychology',2409516211)
,(6680,'Home Economics',9547757555)
,(6768,'Physical Education',4106164833)
,(385,'Chemistry Lab',2958467899)
,(155,'Advanced Calculus',9966170154)
,(6,'Introduction to Physics',0301903182)
,(334,'Statistics',8375959987)
,(15212,'Digital Marketing',1563157152)
,(611,'Introduction to Sociology',6934213106)
,(3498,'Creative Writing',7351586225)
,(75,'Geography',3606008813)
,(2617,'Introduction to Business Management',3933230837)
,(712,'Introduction to Anthropology',9547757555)
,(30101,'Financial Accounting',3261115165)
,(5953,'Introduction to Environmental Science',6934997948)
,(87141,'Introduction to Programming',1710477628)
,(48,'Spanish Language',7283517324)
,(145,'Film Studies',2958467899)
,(108,'Political Science',1563157152)
,(212,'Microeconomics',9719654333)
,(6333,'Introduction to Engineering',2552388485)
,(841,'Introduction to Ethics',9966170154)
,(8,'World History',8399545686)
,(8826,'Data Structures and Algorithms',9236017045)
,(516,'Culinary Arts',2866035003)
,(525,'Introduction to Marketing',1710477628)
,(8889,'Nutrition and Dietetics',7661382628)
,(033,'Cybersecurity',3933230837)
,(37445,'Introduction to Public Speaking',5903776388)
,(0342,'Web Development',9966170154)
,(395,'Cognitive Psychology',2360489623)
,(3,'Introduction to Economics',5527432916)
,(66,'Introduction to Sociology',8484028275)
,(12,'Music Theory',2409516211)
,(37,'Art History',7288235270)
,(76,'Organizational Behavior',0288563638)
,(680,'Digital Photography',6497399429)
,(28,'Environmental Studies',2958467899)
,(70,'Introduction to Philosophy',8399545686)
,(34796,'Research Methods',2851158546)
,(82382,'Human Anatomy',6385237427)
,(7,'Creative Arts',1823222676)
,(297,'Entrepreneurship',2866035003)
,(9299,'Introduction to Linguistics',1190007312)
,(702,'Tax Accounting',3696696862)
,(8591,'Managerial Accounting',3606008813)
,(2682,'Marketing Management',7801123107)
,(38,'Computer Networks',7351586225)
,(04,'Introduction to Astronomy',2722352044)
,(2,'Introduction to Education',3117582983)
,(251,'Travel and Tourism',4285145626)
,(59964,'Introduction to Graphic Design',4920366299)
,(129,'Computer Graphics',9719654333)
,(9043,'Medical Terminology',9236017045)
,(995,'Zoology',1563157152);

INSERT INTO ITPerson(StaffId,PhoneNum) VALUES
 (6404411547,'202-399-5299')
,(4847716124,'789-963-3021')
,(1958315710,'977-223-0736')
,(4993675240,'788-281-8454')
,(5454319546,'937-951-0661')
,(1733840613,'822-764-4317')
,(7159087461,'935-547-3174')
,(6820388063,'626-490-0140')
,(2216673692,'420-648-1921')
,(5741532802,'209-816-6977')
,(1962901823,'823-998-0996')
,(7872970554,'778-289-0943')
,(2420830105,'945-156-0693')
,(0741783649,'817-221-4189')
,(9778612722,'170-940-7983')
,(1278448195,'826-305-9628')
,(6294703387,'818-304-4266')
,(1018285954,'339-831-4103')
,(2261097638,'452-511-2115')
,(1629579416,'652-340-6511')
,(8591315766,'921-119-2104')
,(6382227242,'342-660-5540')
,(4650247519,'797-118-9416')
,(8038801261,'509-494-0406')
,(4565655470,'692-978-8992')
,(7325708300,'670-604-2453')
,(2711576175,'179-191-9751')
,(2966674741,'776-386-3821')
,(2050478399,'917-284-6031')
,(8139365408,'704-250-9915')
,(4949849018,'134-852-3521')
,(3613221624,'323-983-5437')
,(6989457686,'780-131-9716')
,(2448671044,'866-882-7485')
,(2982536897,'573-434-7035')
,(5227533121,'665-708-3440')
,(8451993907,'388-636-3752')
,(3923210922,'982-822-1899')
,(2976955085,'883-446-0630')
,(5171220123,'486-269-6704')
,(7018491207,'170-608-8288')
,(1152568337,'638-808-1195')
,(9728613725,'610-931-3757')
,(0613989589,'665-505-1773')
,(2136017020,'765-334-6301')
,(0341338400,'691-699-9419')
,(1518564402,'533-776-6679')
,(4240302234,'469-641-1271')
,(1587647540,'690-880-2654')
,(9256499452,'967-842-1831')
,(0073865168,'598-783-3155')
,(9435075606,'645-404-9072')
,(1180955676,'217-587-3973')
,(2069939979,'218-148-3099')
,(9783232592,'588-440-8048')
,(5030919155,'573-365-1721')
,(7728988107,'306-854-3673')
,(0832424730,'402-524-8788')
,(2761170458,'485-931-9180')
,(8756048041,'714-822-1191');


INSERT INTO Building(BuildingId,IsActive,Floors,BuildingName,StaffId) VALUES
 ('01HV2J8M5045Y2Y5ESEQGDHADQ',false,4,'Smith Hall',6262446117)
,('01HV2J8NAWQTZ3YSHZ3AS1RXP4',false,3,'Jones Building',0961680881)
,('01HV2J8PHS7MEXP84FD3HN1BY3',false,5,'Williams Tower',4048493523)
,('01HV2J8QQK9WBFDRM47EV86H14',true,10,'Johnson House',1770515801)
,('01HV2J8RY9YBFGQS7RRKXJ8T1R',true,12,'Brown Residence',0888522665)
,('01HV2J8T3RBQTM1BX5QC08N6MN',true,7,'Taylor Building',9528742769)
,('01HV2J8VA74N6KVFYSZBV22A1T',true,5,'Miller Hall',9752415539)
,('01HV2J8WGF9YYA9E72SAPQEAZ3',false,8,'Clark Tower',9602497203)
,('01HV2J8XQ4XSZT91V4QA5546Y1',true,3,'Wilson House',4804001123)
,('01HV2J8YWV4B4DNS5FAWZ1N78S',true,6,'Anderson Hall',2177364418)
,('01HV2J9032QKKV580CFQBVZAKA',true,15,'Moore Building',0032418175)
,('01HV2J919KARD5F34816GWJPX2',true,8,'Thomas Tower',7220851766)
,('01HV2J92FTE1A8VA0457ZS17EQ',false,3,'Jackson Hall',4898769306)
,('01HV2J93PBAZEYT2MZR1M9Q3RB',false,4,'Adams Residence',3872113135)
,('01HV2J94VXNB3B8P3GMTVBVFQH',false,6,'Kennedy Building',3807594531)
,('01HV2J962AJ85VD0RJE13KCSP7',false,20,'Nixon Tower',0197977758)
,('01HV2J978N7BJW3ZZRFD0W18JJ',false,9,'Monroe Hall',2681839386)
,('01HV2J98EWZJTM282F5P0HK162',true,4,'Roosevelt House',2582423823)
,('01HV2J99P5FBVRDXRKV0EK0PHK',false,5,'Washington Residence',9161870218)
,('01HV2J9AV2XMBFP1FP85HY3R1D',false,8,'Jefferson Tower',3426593955)
,('01HV2J9C28ZHH6GN5G9C0KAVVF',true,4,'Lincoln Hall',2627293729)
,('01HV2J9D8C1A9WP7JZ8YVYJXBJ',true,7,'Kennedy House',9516906753)
,('01HV2J9EDTJQZ10F0X8NK1N77T',false,9,'Eisenhower Building',9964302681)
,('01HV2J9FMPA6FWDNQMTHADAX35',false,6,'Truman Tower',1235902013)
,('01HV2J9GV3AYD4CAQ1XRFKTC6D',true,22,'Clinton Hall',1089236115)
,('01HV2J9J0Y9E8VRA4DC8P3W00T',true,4,'Jackson Residence',8076214033)
,('01HV2J9K7V4KEB48BY5DY2CBS1',false,10,'Franklin Building',7164255652)
,('01HV2J9MDAYWSXF3BPGRJ45EHJ',true,9,'Madison Tower',6399239702)
,('01HV2J9NKQD74QE11FYJ108WRP',false,3,'Wilson Hall',0468979301)
,('01HV2J9PSRCKZ5H7ESEAHEE06C',false,7,'Monroe Tower',7138992688)
,('01HV2J9R06G6PKMDF3Z9VNRBXY',false,3,'Adams Building',0108046982)
,('01HV2J9S1E6PEDEQWBKS6QDPP7',true,3,'Jefferson Hall',2869359691)
,('01HV2J9SR2ZEERGE8R8CFND8TT',true,4,'Lincoln Tower',0453744362)
,('01HV2J9TEQ0S08G53X875SMD7B',false,9,'Roosevelt Building',6301275896)
,('01HV2J9V5ECRTKDDGEZDANH5RS',true,18,'Truman House',9923973581)
,('01HV2J9VW1DXSW49ZR7ANHP72M',false,5,'Kennedy Residence',5840972223)
,('01HV2J9WJK9C63BVHHNHSMJE7Y',true,6,'Lincoln Tower',6391857520)
,('01HV2J9X95DWW4SES79PT04H53',false,7,'Kennedy Tower',3309626016)
,('01HV2J9XZQQBYM33B7DRJS2N9W',false,4,'Lincoln Building',5423339715)
,('01HV2J9YPEFSAVFA2G31GVST6K',false,6,'Kennedy Hall',3960405278)
,('01HV2J9ZD2MVF8H0YNTEF7K4R9',true,5,'Madison House',3987591250)
,('01HV2JA03QTWKX6YJRBJ6D62GZ',false,3,'Adams Hall',9958486083)
,('01HV2JA0TBN4GC3N15YZX3GGBS',false,4,'Jefferson Tower',9334177217)
,('01HV2JA1H2880DXPSSWW69TEP8',true,6,'Lincoln House',5144394752)
,('01HV2JA27Q6S8360ZYR8X1QY5K',true,8,'Kennedy Tower',7223137339)
,('01HV2JA2YB02E0WA0VK3XMSK8Z',false,10,'Roosevelt Building',8056555307)
,('01HV2JA3N0XB0FE07E8FGHFV7E',true,5,'Madison House',4501885939)
,('01HV2JA4BJTSZYQG79V0DJAQGA',true,12,'Kennedy Residence',1009517651)
,('01HV2JA526RVXD5AXV605B1035',true,22,'Lincoln Tower',3666363032)
,('01HV2JA5RWR16DWTKBDAW3K314',false,7,'Jefferson Tower',3905940469)
,('01HV2JA6FET3FK688BD6D8985G',false,9,'Madison Building',6753092536)
,('01HV2JA7636T7HWPQHYDK2H2VH',true,3,'Adams Hall',1297745159)
,('01HV2JA7WSYP1HT14X84KA4XYN',true,4,'Jefferson Tower',0742251268)
,('01HV2JA8K97CXVBQ25R4GAPHHS',false,6,'Lincoln Tower',9153584635)
,('01HV2JA99YBF0EQRJKRZT0D0CW',true,7,'Madison Building',9753683227)
,('01HV2JAA0GNS5EYVB50E9RK1PA',false,4,'Jefferson Residence',4710478260)
,('01HV2JAAQ296B9W3DZGARA0MTZ',false,5,'Washington Tower',5586223791)
,('01HV2JABDPDAHQCSNEWFF0HNQM',true,7,'Lincoln Residence',7948607773)
,('01HV2JAC4BETXZMJ267HYC69ZH',false,8,'Madison Hall',4061148869)
,('01HV2JACTWKB5Z6JACV27F9VZP',false,9,'Adams House',4098889943);

INSERT INTO Cleaner(CleanerId,FirstName,LastName,Email,MiddleName,Phone) VALUES
 (3163574742,'Linc','Bettles','lbettles0@netvibes.com','Intéressant','127-996-5956')
,(2370847700,'Gerhard','Probey','gprobey1@g.co','Estée','451-927-0668')
,(6331731407,'Jemima','Gavan','jgavan2@cocolog-nifty.com','Aí','706-418-2714')
,(2310291293,'Erskine','Krzyzaniak','ekrzyzaniak3@domainmarket.com','Gaëlle','249-820-4368')
,(0156877708,'Faye','Franca','ffranca4@yandex.ru','Judicaël','446-360-0289')
,(8997798626,'Donielle','Saltrese','dsaltrese5@who.int','Naëlle','352-396-0535')
,(5018295538,'Lula','Doldon','ldoldon6@ucoz.ru','Åslög','255-506-2510')
,(0777551322,'Garrot','Senter','gsenter7@meetup.com','Eléa','547-442-0406')
,(3756300196,'Kilian','Edmonstone','kedmonstone8@discuz.net','Personnalisée','348-196-9607')
,(3640715292,'Scotty','Scoon','sscoon9@shareasale.com','Annotés','204-295-3303')
,(0008638527,'Kacy','Stirland','kstirlanda@netlog.com','Clémentine','202-741-8421')
,(4721164262,'Jo','Stratley','jstratleyb@odnoklassniki.ru','Miléna','113-363-5800')
,(3976546682,'Cassaundra','Nise','cnisec@npr.org','Rachèle','412-718-1009')
,(5489266961,'Stearne','Hucker','shuckerd@clickbank.net','Marie-noël','267-803-7976')
,(9947865649,'Colleen','Randle','crandlee@liveinternet.ru','Marie-noël','811-743-3546')
,(0355568411,'Gill','Cursons','gcursonsf@newyorker.com','Gaétane','227-885-1432')
,(2223827004,'Luciano','Siene','lsieneg@nbcnews.com','Maïlys','989-955-0821')
,(0106886290,'Elisa','Reaveley','ereaveleyh@hud.gov','Réservés','680-587-5416')
,(6775793316,'Lorianna','Luckey','lluckeyi@eepurl.com','Noëlla','286-513-9849')
,(7944751683,'Katherina','Burkert','kburkertj@1688.com','Annotée','659-834-5476')
,(9010592871,'Mellisent','Base','mbasek@sina.com.cn','Célestine','832-897-1928')
,(9950648742,'Willie','Jonuzi','wjonuzil@naver.com','Thérèse','718-369-7109')
,(1398891878,'Tera','Bartolomeazzi','tbartolomeazzim@businessinsider.com','Börje','975-336-1567')
,(2221804686,'Merrili','D''Arrigo','mdarrigon@furl.net','Léana','869-174-0200')
,(8656351052,'Tobiah','Farnell','tfarnello@reddit.com','Laurène','320-296-0471')
,(1841297267,'Markus','Massen','mmassenp@umich.edu','Ráo','623-873-9842')
,(6612129980,'Jacquenetta','Baudet','jbaudetq@edublogs.org','Táng','492-491-6389')
,(0381835588,'Felicdad','Pierro','fpierror@sfgate.com','Néhémie','666-319-1077')
,(8445685139,'Aldo','Brooking','abrookings@paypal.com','Cloé','608-850-4651')
,(5692918781,'Wilhelm','Rosenkrantz','wrosenkrantzt@miitbeian.gov.cn','Laïla','683-491-7376')
,(6836057703,'Roderich','Ivakin','rivakinu@telegraph.co.uk','Lyséa','931-969-8542')
,(2382421290,'Ara','Goodinson','agoodinsonv@comsenz.com','Yè','929-695-5957')
,(2562248406,'Jenelle','Huc','jhucw@chron.com','Clémence','892-772-0111')
,(6583152584,'Nels','Bleckly','nblecklyx@jiathis.com','Félicie','229-929-0155')
,(8192926001,'Elset','Fancott','efancotty@aboutads.info','Kévina','135-765-3339')
,(9230771112,'Melitta','Luke','mlukez@cafepress.com','Annotée','409-279-3865')
,(4153850594,'Vevay','Menichino','vmenichino10@de.vu','Athéna','992-522-7965')
,(2047139864,'Benedikta','Armsden','barmsden11@census.gov','Wá','401-348-7075')
,(1654084786,'Sada','Hessel','shessel12@spiegel.de','Chloé','669-641-7811')
,(1165609312,'Liane','Cantrill','lcantrill13@about.com','Léone','417-422-9048')
,(1090948905,'Estella','Elam','eelam14@shareasale.com','Vénus','524-111-1506')
,(4791983424,'Marci','Ollive','mollive15@simplemachines.org','Loïca','522-826-5665')
,(8064788285,'Sib','Drane','sdrane16@fotki.com','Faîtes','902-494-2520')
,(0807121266,'Marieann','Coxhead','mcoxhead17@economist.com','Kallisté','228-188-7085')
,(1838423389,'Shelton','Hamsley','shamsley18@comsenz.com','Irène','532-922-5776')
,(5444322587,'Ardene','Sutcliffe','asutcliffe19@freewebs.com','Loïca','107-789-1719')
,(1617789062,'Kaylee','Hurring','khurring1a@go.com','Françoise','342-460-0616')
,(0162319037,'Shannon','Corran','scorran1b@smh.com.au','Geneviève','162-224-0735')
,(0298639599,'Samuele','Bergstrand','sbergstrand1c@technorati.com','Cléopatre','305-324-1326')
,(4073757288,'Ruprecht','Pretley','rpretley1d@shutterfly.com','Garçon','418-555-3349')
,(0203012917,'Claiborne','Zylbermann','czylbermann1e@kickstarter.com','Solène','742-818-2015')
,(4016915082,'Jeanelle','Goulter','jgoulter1f@irs.gov','Maëly','827-605-9998')
,(4859645316,'Farica','Nuss','fnuss1g@hibu.com','Liè','783-313-1797')
,(2423120729,'Gerda','Sollner','gsollner1h@barnesandnoble.com','Desirée','119-719-4313')
,(0021814201,'Adara','Ruggen','aruggen1i@timesonline.co.uk','Maéna','621-543-5921')
,(3855317984,'Amby','Gwin','agwin1j@squarespace.com','Mélissandre','827-284-6710')
,(2022841034,'Hort','Harrill','hharrill1k@google.it','Maëlys','578-354-2994')
,(6936470408,'Mickie','Bizley','mbizley1l@facebook.com','Loïca','966-679-1674')
,(5692688662,'Mallorie','Suff','msuff1m@squidoo.com','Mélodie','189-399-7382')
,(2227752904,'Kaycee','Bamblett','kbamblett1n@psu.edu','Laïla','975-812-4784');


