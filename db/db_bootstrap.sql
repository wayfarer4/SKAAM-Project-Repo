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
    StaffId    VARCHAR(15) PRIMARY KEY,
    Email      VARCHAR(75)     NOT NULL,
    FirstName  VARCHAR(50)     NOT NULL,
    MiddleName VARCHAR(50),
    LastName   VARCHAR(50)     NOT NULL
);

CREATE TABLE IF NOT EXISTS Class
(
    CourseId   BIGINT PRIMARY KEY,
    ClassName  VARCHAR(50),
    StaffId    VARCHAR(15),
    CONSTRAINT fk01
        FOREIGN KEY (StaffId) REFERENCES Professor (StaffId)
            ON UPDATE cascade ON DELETE restrict
);


CREATE TABLE IF NOT EXISTS ITPerson
(
    StaffId   BIGINT PRIMARY KEY,
    PhoneNum  VARCHAR(15),
    UNIQUE INDEX uq_idx_phone_num(PhoneNum)
);

CREATE TABLE IF NOT EXISTS BuildingManager (
    StaffId BIGINT PRIMARY KEY,
    Email VARCHAR(75),
    FirstName  VARCHAR(50)     NOT NULL,
    MiddleName VARCHAR(50),
    LastName   VARCHAR(50)     NOT NULL
);

CREATE TABLE IF NOT EXISTS Building (
    BuildingId  VARCHAR(40) PRIMARY KEY,
    isActive BOOLEAN DEFAULT true,
    Floors int,
    BuildingName VARCHAR(50),
    StaffId BIGINT,
    CONSTRAINT fk06
        FOREIGN KEY (StaffId) REFERENCES BuildingManager (StaffId)
        ON UPDATE cascade ON DELETE restrict
);


CREATE TABLE IF NOT EXISTS Spaces
(
    SpaceId   BIGINT PRIMARY KEY,
    BuildingId  VARCHAR(40),
    IsInAcademicBuilding BOOLEAN DEFAULT true,
    IsAvailable BOOLEAN DEFAULT true,
    CONSTRAINT fk2
        FOREIGN KEY (BuildingId) REFERENCES Building (BuildingId)
        ON UPDATE cascade
);



CREATE TABLE IF NOT EXISTS Classroom (
    ClassroomId BIGINT PRIMARY KEY,
    CourseId BIGINT,
    StaffId BIGINT,
    SpaceId BIGINT,
    CONSTRAINT fk03
        FOREIGN KEY (CourseId) REFERENCES Class (CourseId)
        ON UPDATE cascade,
    CONSTRAINT fk04
        FOREIGN KEY (StaffId) REFERENCES ITPerson (StaffId)
        ON UPDATE cascade ON DELETE restrict,
     CONSTRAINT fk05
        FOREIGN KEY (SpaceId) REFERENCES Spaces (SpaceId)
        ON UPDATE cascade ON DELETE restrict
);


CREATE TABLE IF NOT EXISTS Cleaner (
    CleanerId BIGINT PRIMARY KEY,
    Email VARCHAR(75),
    FirstName  VARCHAR(50)     NOT NULL,
    MiddleName VARCHAR(50),
    LastName   VARCHAR(50)     NOT NULL,
    Phone VARCHAR(15),
    UNIQUE INDEX uq_idx_phone(Phone)
);


CREATE TABLE IF NOT EXISTS Incident (
    IncidentId BIGINT PRIMARY KEY,
    IncidentType VARCHAR(75),
    IncidentTime DATETIME,
    IncidentName VARCHAR(100),
    CleanerId BIGINT,
    CONSTRAINT fk07
        FOREIGN KEY (CleanerId) REFERENCES Cleaner (CleanerId)
        ON UPDATE cascade ON DELETE restrict
);


CREATE TABLE IF NOT EXISTS Student (
    NUId BIGINT PRIMARY KEY,
    Email VARCHAR(75),
    FirstName  VARCHAR(50)     NOT NULL,
    MiddleName VARCHAR(50),
    LastName   VARCHAR(50)     NOT NULL,
    isClubLead BOOLEAN DEFAULT false 
);


CREATE TABLE IF NOT EXISTS Booking (
    BookingId BIGINT PRIMARY KEY,
    SpaceId BIGINT,
    NUId BIGINT,
    CONSTRAINT fk08
        FOREIGN KEY (NUId) REFERENCES Student (NUId)
        ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk09
        FOREIGN KEY (SpaceId) REFERENCES Spaces (SpaceId)
        ON UPDATE cascade ON DELETE restrict
);


CREATE TABLE IF NOT EXISTS BookingDetails (
    BookingId BIGINT,
    BookingNameEvent VARCHAR(75),
    PRIMARY KEY (BookingId, BookingNameEvent),
    BookingTime DATETIME NOT NULL,
    CheckedIn DATETIME,  
    BookingLength int NOT NULL, 
    CONSTRAINT fk10
        FOREIGN KEY (BookingId) REFERENCES Booking (BookingId)
        ON UPDATE cascade ON DELETE cascade 
);


CREATE TABLE IF NOT EXISTS SpaceCleaners (
    SpaceId BIGINT,
    CleanerId BIGINT,
    PRIMARY KEY (SpaceId, CleanerId),
    CONSTRAINT fk11
        FOREIGN KEY (SpaceId) REFERENCES Spaces (SpaceId)
        ON UPDATE cascade ON DELETE restrict,
     CONSTRAINT fk12
        FOREIGN KEY (CleanerId) REFERENCES Cleaner (CleanerId)
        ON UPDATE cascade ON DELETE restrict
);

-- Add sample data. 
INSERT INTO Professor(StaffId, Email, FirstName, MiddleName, LastName) VALUES
 ('8924663895','lganing0@dell.com','Lida','Lynn','Ganing')
,('1563157152','psaill1@dropbox.com','Rawley','Pascal','Saill')
,('7661382628','mkelberer2@altervista.org','Harriott','Maggy','Kelberer')
,('2409516211','mgoldstone3@instagram.com','Cris','Miquela','Goldstone')
,('9966170154','fspataro4@salon.com','Wendy','Fair','Spataro')
,('9678000784','ominghi5@vk.com','Brooks','Oren','Minghi')
,('6497399429','lcorbert6@list-manage.com','Terrye','Laurent','Corbert')
,('1940790387','fmatuszyk7@meetup.com','Roddy','Francois','Matuszyk')
,('1190007312','tburker8@who.int','Randy','Tannie','Burker')
,('7801123107','wciccarelli9@cnbc.com','Willamina','Winston','Ciccarelli')
,('5903776388','wmumma@deviantart.com','Carmita','Wilmette','Mumm')
,('5739328527','mpearmainb@pcworld.com','Charmaine','Meriel','Pearmain')
,('4106164833','mheritegec@theatlantic.com','Deedee','Maryl','Heritege')
,('3261115165','nbaudinsd@fastcompany.com','Foster','Northrop','Baudins')
,('2958467899','pverdeye@twitpic.com','Briggs','Phebe','Verdey')
,('2614078298','hpimlettf@earthlink.net','Bobbie','Horten','Pimlett')
,('7283517324','gdobeyg@fc2.com','Joyann','Gianni','Dobey')
,('7121802848','csollnerh@ebay.com','Sergent','Cyril','Sollner')
,('7351586225','jwallentini@tinypic.com','Lyman','Jens','Wallentin')
,('3117582983','mkinnockj@house.gov','Wylie','Maible','Kinnock')
,('6934997948','dyemmk@vinaora.com','Griffin','Drugi','Yemm')
,('6385237427','mwagerl@aboutads.info','Letti','Melloney','Wager')
,('7288235270','cslavinm@mozilla.org','Howie','Cesar','Slavin')
,('2035381703','lcorleyn@china.com.cn','Giacobo','Loralie','Corley')
,('4920366299','skamallo@acquirethisname.com','Kristo','Stevena','Kamall')
,('6934213106','aswyerp@prweb.com','Emalia','Antonia','Swyer')
,('0864654456','rblindtq@linkedin.com','Bryn','Raleigh','Blindt')
,('5527432916','lstepneyr@pinterest.com','Willi','Leighton','Stepney')
,('7795263895','cforms@google.it','Chery','Clair','Form')
,('2866035003','bagettt@edublogs.org','Wendeline','Berthe','Agett')
,('0301903182','mcluttonu@webmd.com','Frazer','Merilee','Clutton')
,('3933230837','ehowgillv@pinterest.com','Lynnet','Edna','Howgill')
,('9211260868','nmacaulayw@youtu.be','Laurens','Normy','MacAulay')
,('1171095333','kelletonx@nydailynews.com','Ax','Kerby','Elleton')
,('6465507579','fkingmany@cnbc.com','Kaye','Francklin','Kingman')
,('7848961249','gbillinghamz@cam.ac.uk','Fairleigh','Gertrudis','Billingham')
,('3606008813','bdressel10@zimbio.com','Sanford','Benny','Dressel')
,('7434670614','hcabral11@howstuffworks.com','Juli','Hilarius','Cabral')
,('1710477628','babramino12@dropbox.com','Viviana','Benjie','Abramino')
,('3666357415','smorsom13@blog.com','Meredithe','Stefano','Morsom')
,('8484028275','koffner14@zdnet.com','Howard','Karlis','Offner')
,('6832199414','brockwill15@github.io','Carmine','Bartholomew','Rockwill')
,('6107720596','fhaskur16@nbcnews.com','Kennie','Frederica','Haskur')
,('8399545686','mbonde17@adobe.com','Emelia','Maurita','Bonde')
,('2722352044','kbillington18@google.nl','Megan','Kelvin','Billington')
,('4424215288','liveson19@com.com','Say','Lutero','Iveson')
,('2552388485','mzavittieri1a@msu.edu','Thaddus','Mohandis','Zavittieri')
,('9995721937','eflewett1b@youtu.be','Lou','Eunice','Flewett')
,('0288563638','qhouldin1c@bandcamp.com','Cherri','Quentin','Houldin')
,('9547757555','cczadla1d@fc2.com','Maggi','Cybil','Czadla')
,('9719654333','dhay1e@about.me','Marys','Daveen','Hay')
,('2851158546','sdan1f@google.co.jp','Albie','Shep','Dan')
,('9236017045','msuckling1g@sciencedaily.com','Lombard','Micki','Suckling')
,('2360489623','ckondratyuk1h@altervista.org','Pepito','Coraline','Kondratyuk')
,('5174679194','plloyds1i@51.la','Vincenty','Phebe','Lloyds')
,('4285145626','smarin1j@comcast.net','Marnie','Salli','Marin')
,('8375959987','alegrand1k@shareasale.com','Thornton','Arden','Legrand')
,('1823222676','dsolano1l@twitpic.com','Nikola','Diego','Solano')
,('6486892714','fspragg1m@marketwatch.com','Gabriel','Fielding','Spragg')
,('3696696862','hwink1n@theglobeandmail.com','Francoise','Harmonie','Wink');

INSERT INTO Student(NUId,FirstName,LastName,Email,MiddleName,isClubLead) VALUES
 (0328897256,'Doretta','Duinbleton','fduinbleton0@ed.gov','Farley',true)
,(3938493038,'Annaliese','Sainsbury','hsainsbury1@china.com.cn','Helaina',false)
,(3077631962,'Murray','Landsborough','mlandsborough2@ifeng.com','Marlo',false)
,(2381093613,'Stella','Lucks','klucks3@shop-pro.jp','Kaleb',false)
,(7477093937,'Thoma','Ozanne','aozanne4@cornell.edu','Aleece',false)
,(9163289342,'Rriocard','Bachmann','abachmann5@simplemachines.org','Andonis',true)
,(3422740406,'Oralle','Tottie','etottie6@dedecms.com','Egan',false)
,(6703357471,'Howie','Kirtlan','mkirtlan7@bloglines.com','Merry',true)
,(5998501098,'Gretal','Johnston','fjohnston8@bloglovin.com','Faythe',true)
,(3019939291,'Gipsy','Mulrenan','cmulrenan9@cnn.com','Cassondra',true)
,(8380369068,'Syd','Elldred','ielldreda@ovh.net','Irina',true)
,(2633546315,'Pooh','Butterwick','sbutterwickb@mac.com','Sascha',true)
,(0150163525,'Arlyn','Rubega','crubegac@amazonaws.com','Corny',true)
,(7794824869,'Lindsay','Battyll','dbattylld@joomla.org','Desmund',true)
,(0884024261,'Henrietta','Assante','sassantee@gnu.org','Stacie',true)
,(8655206326,'Guntar','Ranscomb','mranscombf@ehow.com','Mackenzie',false)
,(8953645220,'Salvatore','Gabbetis','lgabbetisg@theatlantic.com','Lanny',true)
,(9019075179,'Karlens','Benedettini','kbenedettinih@google.co.uk','Kenn',false)
,(5435712122,'Kevin','Lavelle','elavellei@privacy.gov.au','Ellswerth',true)
,(2636354654,'Upton','Munroe','lmunroej@clickbank.net','Lizzy',true)
,(6329000980,'Burgess','Stearndale','bstearndalek@networkadvertising.org','Benyamin',true)
,(8936937685,'Malory','Plume','fplumel@pbs.org','Florian',true)
,(0843910968,'Karin','Testro','itestrom@rambler.ru','Inge',false)
,(1613682492,'Jacquie','Jedrzaszkiewicz','ljedrzaszkiewiczn@businesswire.com','Lorettalorna',true)
,(9261669654,'Jamaal','Rutty','lruttyo@fema.gov','Linn',true)
,(6276374857,'Nicolis','Thonger','dthongerp@fema.gov','Dorolice',false)
,(6491913783,'Ludwig','Yoseloff','dyoseloffq@tinyurl.com','Demott',false)
,(2104658934,'Thom','Jumont','tjumontr@list-manage.com','Tessie',true)
,(0291645003,'Robinson','Read','areads@blogspot.com','Artair',true)
,(2889118665,'Bailey','Coggeshall','bcoggeshallt@irs.gov','Brita',false)
,(0372091849,'Brandea','Crilley','kcrilleyu@mapquest.com','Kane',true)
,(5107080669,'Karon','Emeline','aemelinev@tmall.com','Avictor',false)
,(5185352523,'Rutherford','McTavy','vmctavyw@tripadvisor.com','Velma',true)
,(7557529294,'Bear','Somerled','ssomerledx@stumbleupon.com','Stu',false)
,(0201287927,'Terese','Stabler','establery@godaddy.com','Eziechiele',false)
,(1496882490,'Rafe','Beniesh','rbenieshz@odnoklassniki.ru','Ryley',false)
,(9714339243,'Desmond','Sherr','esherr10@mediafire.com','Ethelda',false)
,(8056642595,'Kikelia','Derisley','cderisley11@seesaa.net','Christan',true)
,(8295190873,'Viva','Semrad','jsemrad12@go.com','Joann',false)
,(7335626277,'Adamo','Saynor','dsaynor13@skype.com','Donnie',true)
,(2834316295,'Gianina','Irlam','cirlam14@skyrock.com','Conan',false)
,(5310155716,'Lesley','Hurch','lhurch15@webnode.com','Leshia',false)
,(0340867841,'Evan','McElwee','pmcelwee16@angelfire.com','Pippa',false)
,(5618837692,'Janaye','Ockwell','jockwell17@nydailynews.com','Joice',true)
,(6595945649,'Kristoforo','Holborn','hholborn18@dmoz.org','Huntington',false)
,(7583636094,'Clarke','Petrovykh','gpetrovykh19@un.org','Genni',true)
,(3761481284,'Dollie','Bannester','abannester1a@drupal.org','Ally',false)
,(2191535879,'Cordell','Crockley','hcrockley1b@google.cn','Hill',false)
,(3461102660,'Gusty','Ferneley','aferneley1c@usda.gov','Alvinia',true)
,(6951987068,'Kimberley','Antonellini','jantonellini1d@histats.com','Johna',false)
,(3408108668,'Charla','Postians','bpostians1e@myspace.com','Benni',true)
,(8719407157,'Chaddie','Ravilious','bravilious1f@loc.gov','Benn',false)
,(7585280572,'Chalmers','Luff','jluff1g@sciencedaily.com','Jourdain',true)
,(8010510718,'Arnuad','Roddick','broddick1h@skyrock.com','Becki',true)
,(8889953519,'Sigmund','Palfree','lpalfree1i@noaa.gov','Lana',false)
,(4290280889,'Rogerio','Creelman','wcreelman1j@tamu.edu','Witty',false)
,(0886513081,'Anselma','Romayn','kromayn1k@house.gov','Ky',false)
,(6175026330,'Antoinette','Duff','lduff1l@senate.gov','Lorenza',true)
,(1644210320,'Far','Gerran','cgerran1m@flickr.com','Carlin',false)
,(4312079587,'Lutero','Rome','drome1n@biglobe.ne.jp','Delcina',false);

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
 (44563,'Introduction to Biology','4920366299')
,(0,'English Literature','6934997948')
,(37,'Introduction to Computer Science','1171095333')
,(46,'History of Art','2958467899')
,(4,'Algebra I','9719654333')
,(60,'Introduction to Psychology','2409516211')
,(6680,'Home Economics','9547757555')
,(6768,'Physical Education','4106164833')
,(385,'Chemistry Lab','2958467899')
,(155,'Advanced Calculus','9966170154')
,(6,'Introduction to Physics','0301903182')
,(334,'Statistics','8375959987')
,(15212,'Digital Marketing','1563157152')
,(611,'Introduction to Sociology','6934213106')
,(3498,'Creative Writing','7351586225')
,(75,'Geography','3606008813')
,(2617,'Introduction to Business Management','3933230837')
,(712,'Introduction to Anthropology','9547757555')
,(30101,'Financial Accounting','3261115165')
,(5953,'Introduction to Environmental Science','6934997948')
,(87141,'Introduction to Programming','1710477628')
,(48,'Spanish Language','7283517324')
,(145,'Film Studies','2958467899')
,(108,'Political Science','1563157152')
,(212,'Microeconomics','9719654333')
,(6333,'Introduction to Engineering','2552388485')
,(841,'Introduction to Ethics','9966170154')
,(8,'World History','8399545686')
,(8826,'Data Structures and Algorithms','9236017045')
,(516,'Culinary Arts','2866035003')
,(525,'Introduction to Marketing','1710477628')
,(8889,'Nutrition and Dietetics','7661382628')
,(033,'Cybersecurity','3933230837')
,(37445,'Introduction to Public Speaking','5903776388')
,(0342,'Web Development','9966170154')
,(395,'Cognitive Psychology','2360489623')
,(3,'Introduction to Economics','5527432916')
,(66,'Introduction to Sociology','8484028275')
,(12,'Music Theory','2409516211')
,(999,'Art History','7288235270')
,(76,'Organizational Behavior','0288563638')
,(680,'Digital Photography','6497399429')
,(28,'Environmental Studies','2958467899')
,(70,'Introduction to Philosophy','8399545686')
,(34796,'Research Methods','2851158546')
,(82382,'Human Anatomy','6385237427')
,(7,'Creative Arts','1823222676')
,(297,'Entrepreneurship','2866035003')
,(9299,'Introduction to Linguistics','1190007312')
,(702,'Tax Accounting','3696696862')
,(8591,'Managerial Accounting','3606008813')
,(2682,'Marketing Management','7801123107')
,(38,'Computer Networks','7351586225')
,(16,'Introduction to Astronomy','2722352044')
,(2,'Introduction to Education','3117582983')
,(251,'Travel and Tourism','4285145626')
,(59964,'Introduction to Graphic Design','4920366299')
,(129,'Computer Graphics','9719654333')
,(9043,'Medical Terminology','9236017045')
,(995,'Zoology','1563157152');

INSERT INTO ITPerson(StaffId,PhoneNum) VALUES
 (6404411547, '202-399-5299'),
(4847716124, '789-963-3021'),
(1958315710, '977-223-0736'),
(4993675240, '788-281-8454'),
(5454319546, '937-951-0661'),
(1733840613, '822-764-4317'),
(7159087461, '935-547-3174'),
(6820388063, '626-490-0140'),
(2216673692, '420-648-1921'),
(5741532802, '209-816-6977'),
(1962901823, '823-998-0996'),
(7872970554, '778-289-0943'),
(2420830105, '945-156-0693'),
(741783649, '817-221-4189'),
(9778612722, '170-940-7983'),
(1278448195, '826-305-9628'),
(6294703387, '818-304-4266'),
(1018285954, '339-831-4103'),
(2261097638, '452-511-2115'),
(1629579416, '652-340-6511'),
(8591315766, '921-119-2104'),
(6382227242, '342-660-5540'),
(4650247519, '797-118-9416'),
(8038801261, '509-494-0406'),
(4565655470, '692-978-8992'),
(7325708300, '670-604-2453'),
(2711576175, '179-191-9751'),
(2966674741, '776-386-3821'),
(2050478399, '917-284-6031'),
(8139365408, '704-250-9915'),
(4949849018, '134-852-3521'),
(3613221624, '323-983-5437'),
(6989457686, '780-131-9716'),
(2448671044, '866-882-7485'),
(2982536897, '573-434-7035'),
(5227533121, '665-708-3440'),
(8451993907, '388-636-3752'),
(3923210922, '982-822-1899'),
(2976955085, '883-446-0630'),
(5171220123, '486-269-6704'),
(7018491207, '170-608-8288'),
(1152568337, '638-808-1195'),
(9728613725, '610-931-3757'),
(613989589, '665-505-1773'),
(2136017020, '765-334-6301'),
(341338400, '691-699-9419'),
(1518564402, '533-776-6679'),
(4240302234, '469-641-1271'),
(1587647540, '690-880-2654'),
(9256499452, '967-842-1831'),
(73865168, '598-783-3155'),
(9435075606, '645-404-9072'),
(1180955676, '217-587-3973'),
(2069939979, '218-148-3099'),
(9783232592, '588-440-8048'),
(5030919155, '573-365-1721'),
(7728988107, '306-854-3673'),
(832424730, '402-524-8788'),
(2761170458, '485-931-9180'),
(8756048041, '714-822-1191');

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

INSERT INTO Cleaner(CleanerId, FirstName, LastName, Email, MiddleName, Phone) VALUES
 (3163574742, 'Linc', 'Bettles', 'lbettles0@netvibes.com', 'Intéressant', 1279965956),
 (2370847700, 'Gerhard', 'Probey', 'gprobey1@g.co', 'Estée', 4519270668),
 (6331731407, 'Jemima', 'Gavan', 'jgavan2@cocolog-nifty.com', 'Aí', 7064182714),
 (2310291293, 'Erskine', 'Krzyzaniak', 'ekrzyzaniak3@domainmarket.com', 'Gaëlle', 2498204368),
 (156877708, 'Faye', 'Franca', 'ffranca4@yandex.ru', 'Judicaël', 4463600289),
 (8997798626, 'Donielle', 'Saltrese', 'dsaltrese5@who.int', 'Naëlle', 3523960535),
 (5018295538, 'Lula', 'Doldon', 'ldoldon6@ucoz.ru', 'Åslög', 2555062510),
 (777551322, 'Garrot', 'Senter', 'gsenter7@meetup.com', 'Eléa', 5474420406),
 (3756300196, 'Kilian', 'Edmonstone', 'kedmonstone8@discuz.net', 'Personnalisée', 3481969607),
 (3640715292, 'Scotty', 'Scoon', 'sscoon9@shareasale.com', 'Annotés', 2042953303),
 (8638527, 'Kacy', 'Stirland', 'kstirlanda@netlog.com', 'Clémentine', 2027418421),
 (4721164262, 'Jo', 'Stratley', 'jstratleyb@odnoklassniki.ru', 'Miléna', 1133635800),
 (3976546682, 'Cassaundra', 'Nise', 'cnisec@npr.org', 'Rachèle', 4127181009),
 (5489266961, 'Stearne', 'Hucker', 'shuckerd@clickbank.net', 'Marie-noël', 2678037976),
 (9947865649, 'Colleen', 'Randle', 'crandlee@liveinternet.ru', 'Marie-noël', 8117433546),
 (355568411, 'Gill', 'Cursons', 'gcursonsf@newyorker.com', 'Gaétane', 2278851432),
 (2223827004, 'Luciano', 'Siene', 'lsieneg@nbcnews.com', 'Maïlys', 9899550821),
 (106886290, 'Elisa', 'Reaveley', 'ereaveleyh@hud.gov', 'Réservés', 6805875416),
 (6775793316, 'Lorianna', 'Luckey', 'lluckeyi@eepurl.com', 'Noëlla', 2865139849),
 (7944751683, 'Katherina', 'Burkert', 'kburkertj@1688.com', 'Annotée', 6598345476),
 (9010592871, 'Mellisent', 'Base', 'mbasek@sina.com.cn', 'Célestine', 8328971928),
 (9950648742, 'Willie', 'Jonuzi', 'wjonuzil@naver.com', 'Thérèse', 7183697109),
 (1398891878, 'Tera', 'Bartolomeazzi', 'tbartolomeazzim@businessinsider.com', 'Börje', 9753361567),
 (2221804686, 'Merrili', 'D''Arrigo', 'mdarrigon@furl.net', 'Léana', 8691740200),
 (8656351052, 'Tobiah', 'Farnell', 'tfarnello@reddit.com', 'Laurène', 3202960471),
 (1841297267, 'Markus', 'Massen', 'mmassenp@umich.edu', 'Ráo', 6238739842),
 (6612129980, 'Jacquenetta', 'Baudet', 'jbaudetq@edublogs.org', 'Táng', 4924916389),
 (381835588, 'Felicdad', 'Pierro', 'fpierror@sfgate.com', 'Néhémie', 6663191077),
 (8445685139, 'Aldo', 'Brooking', 'abrookings@paypal.com', 'Cloé', 6088504651),
 (5692918781, 'Wilhelm', 'Rosenkrantz', 'wrosenkrantzt@miitbeian.gov.cn', 'Laïla', 6834917376),
 (6836057703, 'Roderich', 'Ivakin', 'rivakinu@telegraph.co.uk', 'Lyséa', 9319698542),
 (2382421290, 'Ara', 'Goodinson', 'agoodinsonv@comsenz.com', 'Yè', 9296955957),
 (2562248406, 'Jenelle', 'Huc', 'jhucw@chron.com', 'Clémence', 8927720111),
 (6583152584, 'Nels', 'Bleckly', 'nblecklyx@jiathis.com', 'Félicie', 2299290155),
 (8192926001, 'Elset', 'Fancott', 'efancotty@aboutads.info', 'Kévina', 1357653339),
 (9230771112, 'Melitta', 'Luke', 'mlukez@cafepress.com', 'Annotée', 4092793865),
 (4153850594, 'Vevay', 'Menichino', 'vmenichino10@de.vu', 'Athéna', 9925227965),
 (2047139864, 'Benedikta', 'Armsden', 'barmsden11@census.gov', 'Wá', 4013487075),
 (1654084786, 'Sada', 'Hessel', 'shessel12@spiegel.de', 'Chloé', 6696417811),
 (1165609312, 'Liane', 'Cantrill', 'lcantrill13@about.com', 'Léone', 4174229048),
 (1090948905, 'Estella', 'Elam', 'eelam14@shareasale.com', 'Vénus', 5241111506),
 (4791983424, 'Marci', 'Ollive', 'mollive15@simplemachines.org', 'Loïca', 5228265665),
 (8064788285, 'Sib', 'Drane', 'sdrane16@fotki.com', 'Faîtes', 9024942520),
 (807121266, 'Marieann', 'Coxhead', 'mcoxhead17@economist.com', 'Kallisté', 2281887085),
 (1838423389, 'Shelton', 'Hamsley', 'shamsley18@comsenz.com', 'Irène', 5329225776),
 (5444322587, 'Ardene', 'Sutcliffe', 'asutcliffe19@freewebs.com', 'Loïca', 1077891719),
 (1617789062, 'Kaylee', 'Hurring', 'khurring1a@go.com', 'Françoise', 3424600616),
 (162319037, 'Shannon', 'Corran', 'scorran1b@smh.com.au', 'Geneviève', 1622240735),
 (298639599, 'Samuele', 'Bergstrand', 'sbergstrand1c@technorati.com', 'Cléopatre', 3053241326),
 (4073757288, 'Ruprecht', 'Pretley', 'rpretley1d@shutterfly.com', 'Garçon', 4185553349),
 (203012917, 'Claiborne', 'Zylbermann', 'czylbermann1e@kickstarter.com', 'Solène', 7428182015),
 (4016915082, 'Jeanelle', 'Goulter', 'jgoulter1f@irs.gov', 'Maëly', 8276059998),
 (4859645316, 'Farica', 'Nuss', 'fnuss1g@hibu.com', 'Liè', 7833131797),
 (2423120729, 'Gerda', 'Sollner', 'gsollner1h@barnesandnoble.com', 'Desirée', 1197194313),
 (21814201, 'Adara', 'Ruggen', 'aruggen1i@timesonline.co.uk', 'Maéna', 6215435921),
 (3855317984, 'Amby', 'Gwin', 'agwin1j@squarespace.com', 'Mélissandre', 8272846710),
 (2022841034, 'Hort', 'Harrill', 'hharrill1k@google.it', 'Maëlys', 5783542994),
 (6936470408, 'Mickie', 'Bizley', 'mbizley1l@facebook.com', 'Loïca', 9666791674),
 (5692688662, 'Mallorie', 'Suff', 'msuff1m@squidoo.com', 'Mélodie', 1893997382),
 (2227752904, 'Kaycee', 'Bamblett', 'kbamblett1n@psu.edu', 'Laïla', 9758124784);

INSERT INTO Spaces(SpaceId,BuildingId,IsInAcademicBuilding,IsAvailable) VALUES
 (0226266095,'01HV2J98EWZJTM282F5P0HK162',false,true)
,(8359948771,'01HV2J92FTE1A8VA0457ZS17EQ',true,false)
,(0525262342,'01HV2J9C28ZHH6GN5G9C0KAVVF',true,true)
,(0701823224,'01HV2J9SR2ZEERGE8R8CFND8TT',false,true)
,(0269956336,'01HV2J8QQK9WBFDRM47EV86H14',false,false)
,(1186139722,'01HV2J98EWZJTM282F5P0HK162',false,true)
,(0216923751,'01HV2J9D8C1A9WP7JZ8YVYJXBJ',false,false)
,(8486852218,'01HV2J9C28ZHH6GN5G9C0KAVVF',true,true)
,(1551848554,'01HV2J9YPEFSAVFA2G31GVST6K',true,true)
,(7092261929,'01HV2JAA0GNS5EYVB50E9RK1PA',false,true)
,(2307416080,'01HV2J978N7BJW3ZZRFD0W18JJ',true,true)
,(5151476564,'01HV2J919KARD5F34816GWJPX2',false,true)
,(0578871300,'01HV2JACTWKB5Z6JACV27F9VZP',false,true)
,(6780553107,'01HV2J8WGF9YYA9E72SAPQEAZ3',false,true)
,(6448345620,'01HV2J9VW1DXSW49ZR7ANHP72M',true,true)
,(1474814417,'01HV2J9YPEFSAVFA2G31GVST6K',true,true)
,(6430689107,'01HV2JAA0GNS5EYVB50E9RK1PA',true,false)
,(9752927386,'01HV2J9FMPA6FWDNQMTHADAX35',true,false)
,(2519212160,'01HV2J9S1E6PEDEQWBKS6QDPP7',false,false)
,(1541417453,'01HV2J8NAWQTZ3YSHZ3AS1RXP4',true,false)
,(6308943983,'01HV2J9VW1DXSW49ZR7ANHP72M',true,true)
,(0066064864,'01HV2J8XQ4XSZT91V4QA5546Y1',true,true)
,(2863578545,'01HV2J8VA74N6KVFYSZBV22A1T',true,false)
,(1114087459,'01HV2J9R06G6PKMDF3Z9VNRBXY',true,false)
,(0735081905,'01HV2J8VA74N6KVFYSZBV22A1T',false,false)
,(6803427978,'01HV2JA03QTWKX6YJRBJ6D62GZ',true,true)
,(7399678758,'01HV2JA03QTWKX6YJRBJ6D62GZ',false,true)
,(2371914096,'01HV2J9SR2ZEERGE8R8CFND8TT',false,true)
,(0570524512,'01HV2JA526RVXD5AXV605B1035',true,true)
,(8750805266,'01HV2JA0TBN4GC3N15YZX3GGBS',false,true)
,(1969544007,'01HV2J93PBAZEYT2MZR1M9Q3RB',false,true)
,(0602839920,'01HV2J93PBAZEYT2MZR1M9Q3RB',true,false)
,(9927795564,'01HV2JA03QTWKX6YJRBJ6D62GZ',false,true)
,(2453074563,'01HV2JA6FET3FK688BD6D8985G',false,true)
,(5267580848,'01HV2JA99YBF0EQRJKRZT0D0CW',true,false)
,(4542540774,'01HV2JABDPDAHQCSNEWFF0HNQM',false,false)
,(1886440972,'01HV2J9ZD2MVF8H0YNTEF7K4R9',true,false)
,(6539904754,'01HV2J8M5045Y2Y5ESEQGDHADQ',true,true)
,(7619206779,'01HV2J9032QKKV580CFQBVZAKA',true,true)
,(0555276155,'01HV2J9XZQQBYM33B7DRJS2N9W',true,false)
,(7848970159,'01HV2J8RY9YBFGQS7RRKXJ8T1R',true,false)
,(2124854186,'01HV2J9C28ZHH6GN5G9C0KAVVF',true,false)
,(8171677967,'01HV2J8YWV4B4DNS5FAWZ1N78S',true,true)
,(7189990739,'01HV2J9V5ECRTKDDGEZDANH5RS',false,false)
,(9880512162,'01HV2JAA0GNS5EYVB50E9RK1PA',false,true)
,(5769964111,'01HV2J9AV2XMBFP1FP85HY3R1D',true,true)
,(9407996514,'01HV2J8QQK9WBFDRM47EV86H14',false,false)
,(9024427924,'01HV2JA5RWR16DWTKBDAW3K314',true,false)
,(0525395997,'01HV2J9S1E6PEDEQWBKS6QDPP7',false,false)
,(5374167723,'01HV2J962AJ85VD0RJE13KCSP7',true,false)
,(5318305520,'01HV2JACTWKB5Z6JACV27F9VZP',true,true)
,(2081181827,'01HV2JA526RVXD5AXV605B1035',true,false)
,(7272290781,'01HV2JA1H2880DXPSSWW69TEP8',true,true)
,(5931307273,'01HV2J8T3RBQTM1BX5QC08N6MN',true,true)
,(5979333177,'01HV2J9SR2ZEERGE8R8CFND8TT',false,true)
,(2865716600,'01HV2J9NKQD74QE11FYJ108WRP',false,false)
,(8329426947,'01HV2JA4BJTSZYQG79V0DJAQGA',true,false)
,(7198964737,'01HV2J9GV3AYD4CAQ1XRFKTC6D',false,true)
,(8607129104,'01HV2J98EWZJTM282F5P0HK162',true,true)
,(4089129656,'01HV2J9X95DWW4SES79PT04H53',true,true);

INSERT INTO Classroom(ClassroomId,CourseId,StaffId,SpaceId) VALUES
 (8228999976,38,7728988107,0066064864)
,(0609914294,37,1018285954,0602839920)
,(2647004293,6768,2420830105,0735081905)
,(3623517291,033,1180955676,6308943983)
,(5949009460,3498,1180955676,0216923751)
,(7713328130,108,9783232592,0066064864)
,(3815507839,212,9778612722,9407996514)
,(7993445817,48,8038801261,5931307273)
,(6799642849,59964,5030919155,7092261929)
,(5745484926,155,5741532802,8607129104)
,(0375743936,37,9728613725,2307416080)
,(0285502522,841,1629579416,0269956336)
,(2090484292,37,1958315710,7272290781)
,(6518174188,04,8139365408,0602839920)
,(1464718458,28,2448671044,9024427924)
,(2919413767,3,5171220123,6780553107)
,(6525022126,297,0073865168,6430689107)
,(2388946751,334,0341338400,8750805266)
,(8238864771,46,5227533121,0269956336)
,(4077263549,37,9728613725,7272290781)
,(8435767752,0,7018491207,8359948771)
,(5875951222,611,1733840613,5374167723)
,(5507786569,7,2216673692,1186139722)
,(6225645802,0,8139365408,5151476564)
,(0200113224,28,2982536897,8607129104)
,(7446561440,60,6820388063,2863578545)
,(7130177160,212,2982536897,1886440972)
,(6393121343,37,7018491207,0735081905)
,(2057889106,8826,2966674741,0226266095)
,(5230747315,46,1180955676,2124854186)
,(0570327261,516,4240302234,6448345620)
,(0308803779,0,1587647540,8329426947)
,(2479336867,2682,4565655470,5318305520)
,(3624154621,129,1018285954,7272290781)
,(5753423345,37445,8591315766,9407996514)
,(3910623514,385,9256499452,0570524512)
,(0748230912,87141,5227533121,9880512162)
,(0822052377,60,7018491207,5267580848)
,(5002334342,4,2069939979,7848970159)
,(2846976260,155,6820388063,1551848554)
,(8104916300,44563,2711576175,1114087459)
,(2258119766,251,4993675240,1969544007)
,(0849598176,59964,1958315710,2865716600)
,(1523914114,5953,5741532802,0216923751)
,(6878571413,37,1278448195,6803427978)
,(3763990445,8889,2976955085,2863578545)
,(8536728736,28,7872970554,0602839920)
,(1944629041,6,1962901823,7619206779)
,(0640523153,611,9435075606,8359948771)
,(0598539263,82382,0341338400,9024427924)
,(8119637496,38,2136017020,2081181827)
,(2392687889,6768,4949849018,1186139722)
,(5699259635,395,6404411547,5374167723)
,(8746713972,76,1629579416,2453074563)
,(2702979459,9043,2216673692,2124854186)
,(9757007625,2,8451993907,1886440972)
,(9503666899,6680,1180955676,0269956336)
,(7566718355,8591,8756048041,6780553107)
,(5893507940,212,5030919155,7189990739)
,(4973141879,145,2261097638,8486852218);

INSERT INTO Booking(BookingId,SpaceId,NUId) VALUES
 (5619123537,7272290781,0884024261)
,(3205817842,2307416080,6595945649)
,(6832750935,0578871300,3077631962)
,(0584970706,2307416080,2636354654)
,(7739971480,1186139722,6491913783)
,(4948493244,4542540774,2191535879)
,(2783227150,0602839920,3761481284)
,(8316217546,0216923751,5310155716)
,(4463927285,8329426947,2633546315)
,(1263632661,6308943983,1496882490)
,(8638502125,0216923751,3019939291)
,(9658176372,0570524512,7583636094)
,(4691548963,2081181827,5310155716)
,(1983117242,7092261929,5107080669)
,(4570541062,9927795564,2834316295)
,(7288869512,5769964111,7477093937)
,(0235608068,2453074563,7557529294)
,(9599123522,2081181827,5310155716)
,(6616493326,8486852218,7557529294)
,(1466203072,7848970159,8719407157)
,(5987074398,6448345620,2636354654)
,(2810650179,0216923751,3077631962)
,(8360355630,7198964737,9714339243)
,(9695804608,8486852218,6276374857)
,(2859031049,2081181827,7477093937)
,(8739341062,7272290781,8655206326)
,(6460042888,8607129104,5998501098)
,(8792316115,5979333177,7583636094)
,(8773490970,1886440972,8936937685)
,(4859531841,2865716600,0843910968)
,(2703431864,2081181827,5107080669)
,(3967937348,0525395997,7557529294)
,(5075264581,5318305520,9714339243)
,(3647097314,0735081905,2834316295)
,(6389686390,8329426947,5107080669)
,(6790454500,1969544007,9163289342)
,(8930577946,2124854186,8655206326)
,(9601203737,5267580848,3422740406)
,(0251512665,1541417453,8889953519)
,(9901218322,2371914096,1613682492)
,(3278279263,1114087459,9261669654)
,(7425497646,2453074563,0884024261)
,(4197923007,0578871300,4290280889)
,(7276927970,4089129656,7477093937)
,(0115898875,0701823224,7335626277)
,(0770378951,2307416080,8380369068)
,(2905484233,7198964737,2104658934)
,(9396376833,8171677967,5185352523)
,(1381107400,1186139722,2636354654)
,(5298962467,8359948771,0340867841)
,(4136852533,8486852218,8295190873)
,(8166836432,0226266095,2191535879)
,(1129687279,6448345620,3938493038)
,(5979218572,0602839920,5310155716)
,(4926651793,1474814417,6491913783)
,(3301688543,8750805266,5998501098)
,(9674569669,0066064864,2633546315)
,(6132460977,2863578545,3019939291)
,(1280796642,2081181827,6703357471)
,(1502142449,5979333177,0328897256);

INSERT INTO BookingDetails(BookingId,BookingNameEvent,BookingTime,CheckedIn,BookingLength) VALUES
 (3647097314,'Seminar on Entrepreneurship','2023-05-14 13:19:39','2024-01-30 22:16:25',146)
,(1280796642,'Guest Lecture Series','2023-08-21 10:54:12','2024-03-09 21:55:32',129)
,(4570541062,'Annual Science Fair','2023-05-13 04:56:51','2023-12-15 22:34:52',21)
,(1983117242,'Student Council Meeting','2023-09-05 22:37:36','2024-01-22 12:16:05',84)
,(8930577946,'Career Development Workshop','2023-06-07 10:14:05','2023-12-31 11:51:54',132)
,(2859031049,'Art Exhibition','2023-12-21 21:11:27','2023-07-09 01:26:43',139)
,(1280796642,'Literary Club Meeting','2023-06-08 00:04:01','2023-08-09 23:51:11',164)
,(8166836432,'Music Recital','2024-04-13 07:50:13','2023-06-04 03:03:11',16)
,(7425497646,'Sports Day','2024-04-02 22:20:23','2023-09-12 21:23:44',168)
,(4691548963,'Chess Tournament','2023-05-30 20:36:20','2023-09-10 17:26:47',4)
,(0115898875,'Coding Competition','2023-07-26 21:38:54','2024-01-22 20:05:56',32)
,(9674569669,'Hackathon','2023-04-12 22:38:20','2023-12-19 22:19:55',93)
,(6389686390,'Debate Club Meeting','2023-07-20 13:22:08','2024-01-03 04:38:21',89)
,(6832750935,'Film Screening','2023-10-29 23:31:22','2024-03-07 04:09:41',157)
,(7739971480,'Language Exchange Program','2023-07-26 02:15:15','2023-04-17 13:15:13',53)
,(6832750935,'Open Mic Night','2023-07-21 19:19:30','2024-02-17 14:26:42',8)
,(7425497646,'Career Fair','2023-10-15 09:08:49','2023-04-10 11:26:00',73)
,(8792316115,'Seminar on Artificial Intelligence','2024-02-23 11:24:18','2024-04-01 08:39:25',108)
,(6832750935,'Photography Workshop','2023-10-09 12:20:56','2024-02-29 08:32:45',87)
,(2859031049,'Dance Performance','2024-02-15 16:11:12','2023-09-14 12:48:07',136)
,(0235608068,'Music Festival','2024-01-16 19:06:29','2023-12-19 21:58:51',140)
,(8739341062,'Leadership Summit','2024-04-20 00:05:04','2023-11-10 07:15:41',61)
,(1381107400,'Technology Conference','2023-12-21 15:12:50','2024-03-08 13:00:19',141)
,(6389686390,'Science Club Meeting','2024-05-05 15:41:59','2023-07-13 18:26:07',119)
,(8930577946,'Workshop on Public Speaking','2023-11-21 17:14:43','2024-05-14 17:35:35',44)
,(8360355630,'Entrepreneurship Bootcamp','2024-04-24 21:44:19','2023-11-09 12:35:06',19)
,(5619123537,'Annual Theatre Production','2024-01-01 11:52:45','2023-06-30 19:16:33',177)
,(4463927285,'Innovation Summit','2024-01-16 10:19:07','2023-08-28 23:53:15',18)
,(0115898875,'Art Workshop','2023-08-04 13:26:12','2023-08-10 07:56:27',75)
,(9695804608,'Startup Pitch Competition','2023-06-10 07:59:13','2024-03-29 07:54:41',104)
,(1502142449,'Networking Event','2023-11-09 06:59:31','2023-05-12 23:45:24',93)
,(0115898875,'Tech Talk','2024-03-29 20:13:46','2023-05-27 15:14:03',13)
,(5979218572,'Book Club Meeting','2023-08-06 16:12:51','2024-02-23 04:51:45',64)
,(3278279263,'Environmental Sustainability Workshop','2024-03-25 11:21:32','2024-01-07 07:12:45',17)
,(6132460977,'Fitness Class','2023-04-22 14:10:57','2023-07-03 18:18:28',1)
,(9695804608,'Elevator Pitch Competition','2023-11-15 13:32:54','2024-04-07 06:00:36',122)
,(9658176372,'Art Club Meeting','2023-10-09 11:46:52','2024-03-16 09:58:11',15)
,(7425497646,'Technology Expo','2024-03-14 21:27:58','2023-08-05 15:16:13',61)
,(8739341062,'Leadership Workshop','2024-03-23 11:30:34','2024-02-18 18:03:54',93)
,(2859031049,'Fashion Show','2023-10-28 15:39:20','2024-01-01 23:04:43',156)
,(4463927285,'Startup Weekend','2023-10-08 22:28:46','2024-04-19 16:09:51',173)
,(4948493244,'Entrepreneurship Seminar','2023-08-30 08:55:40','2023-12-11 08:24:46',158)
,(8638502125,'Health and Wellness Fair','2023-05-22 01:09:24','2023-09-03 08:58:03',120)
,(7288869512,'Robotics Club Meeting','2023-10-01 06:27:16','2023-06-25 10:49:15',80)
,(9901218322,'Product Demo','2023-08-30 19:12:48','2024-03-01 14:35:44',99)
,(5075264581,'Software Development Workshop','2023-10-27 10:22:51','2024-02-23 15:23:27',70)
,(5619123537,'Drama Club Meeting','2023-06-22 22:17:56','2023-05-17 14:22:26',44)
,(4691548963,'Chess Club Meeting','2024-01-27 02:56:09','2024-02-25 06:23:48',74)
,(8360355630,'Startup Networking Event','2024-04-11 22:51:11','2024-01-19 09:34:09',9)
,(1983117242,'Art Appreciation Session','2024-01-26 12:26:51','2024-01-22 12:16:38',19)
,(1502142449,'Film Club Meeting','2023-04-20 12:47:05','2024-05-13 03:45:39',110)
,(6460042888,'Investment Workshop','2023-09-25 16:30:21','2024-03-17 06:38:38',9)
,(2783227150,'Coding Bootcamp','2024-05-08 16:16:01','2024-02-25 04:19:55',3)
,(3967937348,'Public Speaking Seminar','2023-11-25 13:25:29','2024-05-16 11:51:30',19)
,(1466203072,'Leadership Training','2024-02-03 00:40:49','2023-04-28 11:56:02',120)
,(4136852533,'Science Fair Exhibition','2023-10-22 16:08:11','2024-01-14 03:26:48',167)
,(4197923007,'Creative Writing Workshop','2023-12-21 04:57:49','2023-09-07 22:27:02',23)
,(3301688543,'Programming Contest','2023-04-15 02:59:18','2024-02-08 07:15:28',26)
,(9674569669,'Tech Meetup','2024-01-03 11:47:14','2024-01-05 13:04:56',137)
,(9396376833,'Marketing Workshop','2023-11-02 15:43:09','2024-02-16 07:44:26',147);


INSERT INTO Incident (IncidentId, IncidentType, IncidentTime, IncidentName, CleanerId) VALUES
(1, 'Spill', '2024-04-15 09:30:00', 'Coffee spill in lobby', 3163574742),
(2, 'Broken', '2024-04-15 10:45:00', 'Broken glass in conference room', 2370847700),
(3, 'Stain', '2024-04-15 11:20:00', 'Ink stain on carpet in hallway', 6331731407),
(4, 'Damage', '2024-04-15 12:15:00', 'Damaged furniture in break room', 2310291293),
(5, 'Graffiti', '2024-04-15 13:00:00', 'Graffiti on bathroom wall', 156877708),
(6, 'Leak', '2024-04-15 14:20:00', 'Leak from ceiling in office', 8997798626),
(7, 'Malfunction', '2024-04-15 15:10:00', 'Malfunctioning light in hallway', 5018295538),
(8, 'Spill', '2024-04-15 16:00:00', 'Water spill near reception desk', 777551322),
(9, 'Broken', '2024-04-15 17:30:00', 'Broken chair in meeting room', 3756300196),
(10, 'Stain', '2024-04-16 09:00:00', 'Stain on carpet in elevator', 3640715292),
(11, 'Damage', '2024-04-16 10:15:00', 'Damaged wall in hallway', 8638527),
(12, 'Graffiti', '2024-04-16 11:45:00', 'Graffiti on exterior wall', 4721164262),
(13, 'Leak', '2024-04-16 12:30:00', 'Leak from pipe in restroom', 3976546682),
(14, 'Malfunction', '2024-04-16 13:20:00', 'Malfunctioning elevator', 5489266961),
(15, 'Spill', '2024-04-16 14:45:00', 'Soda spill in break room', 9947865649),
(16, 'Broken', '2024-04-16 15:30:00', 'Broken window in lobby', 355568411),
(17, 'Stain', '2024-04-16 16:20:00', 'Stain on carpet in office', 2223827004),
(18, 'Damage', '2024-04-16 17:10:00', 'Damaged desk in cubicle', 106886290),
(19, 'Graffiti', '2024-04-17 09:45:00', 'Graffiti on bathroom mirror', 6775793316),
(20, 'Leak', '2024-04-17 10:30:00', 'Leak from ceiling in conference room', 7944751683),
(21, 'Malfunction', '2024-04-17 11:15:00', 'Malfunctioning AC unit', 9010592871),
(22, 'Spill', '2024-04-17 12:00:00', 'Milk spill in break room', 9950648742),
(23, 'Broken', '2024-04-17 13:20:00', 'Broken door handle in restroom', 1398891878),
(24, 'Stain', '2024-04-17 14:10:00', 'Stain on upholstery in waiting area', 2221804686),
(25, 'Damage', '2024-04-17 15:00:00', 'Damaged computer monitor', 8656351052),
(26, 'Graffiti', '2024-04-17 16:30:00', 'Graffiti on office window', 1841297267),
(27, 'Leak', '2024-04-17 17:20:00', 'Leak from plumbing under sink', 6612129980),
(28, 'Malfunction', '2024-04-18 09:15:00', 'Malfunctioning printer', 381835588),
(29, 'Spill', '2024-04-18 10:40:00', 'Ink spill on desk', 8445685139),
(30, 'Broken', '2024-04-18 11:25:00', 'Broken light fixture in hallway', 5692918781);



INSERT INTO SpaceCleaners(SpaceId,CleanerId) VALUES
 (0226266095,3163574742)
,(8359948771,3163574742)
,(0525262342,3163574742)
,(0701823224,3163574742)
,(0269956336,3163574742)
,(1186139722,3163574742)
,(0216923751,3163574742)
,(8486852218,3163574742)
,(1551848554,3163574742)
,(7092261929,3163574742)
,(2307416080,3163574742)
,(5151476564,3163574742)
,(0578871300,3163574742)
,(6780553107,3163574742)
,(6448345620,3163574742)
,(1474814417,3163574742)
,(6430689107,3163574742)
,(9752927386,3163574742)
,(2519212160,3163574742)
,(1541417453,3163574742)
,(6308943983,3163574742)
,(0066064864,3163574742)
,(2863578545,3163574742)
,(1114087459,3163574742)
,(0735081905,3163574742)
,(6803427978,3163574742)
,(7399678758,3163574742)
,(2371914096,3163574742)
,(0570524512,3163574742)
,(8750805266,3163574742)
,(1969544007,3163574742)
,(0602839920,3163574742)
,(9927795564,3163574742)
,(2453074563,3163574742)
,(5267580848,3163574742)
,(4542540774,3163574742)
,(1886440972,3163574742)
,(6539904754,3163574742)
,(7619206779,3163574742)
,(0555276155,3163574742)
,(7848970159,3163574742)
,(2124854186,3163574742)
,(8171677967,3163574742)
,(7189990739,3163574742)
,(9880512162,3163574742)
,(5769964111,3163574742)
,(9407996514,3163574742)
,(9024427924,3163574742)
,(0525395997,3163574742)
,(5374167723,3163574742)
,(5318305520,3163574742)
,(2081181827,3163574742)
,(7272290781,3163574742)
,(5931307273,3163574742)
,(5979333177,3163574742)
,(2865716600,3163574742)
,(8329426947,3163574742)
,(7198964737,3163574742)
,(8607129104,3163574742)
,(4089129656,3163574742)
,(0226266095,2370847700)
,(8359948771,2370847700)
,(0525262342,2370847700)
,(0701823224,2370847700)
,(0269956336,2370847700)
,(1186139722,2370847700)
,(0216923751,2370847700)
,(8486852218,2370847700)
,(1551848554,2370847700)
,(7092261929,2370847700)
,(2307416080,2370847700)
,(5151476564,2370847700)
,(0578871300,2370847700)
,(6780553107,2370847700)
,(6448345620,2370847700)
,(1474814417,2370847700)
,(6430689107,2370847700)
,(9752927386,2370847700)
,(2519212160,2370847700)
,(1541417453,2370847700)
,(6308943983,2370847700)
,(0066064864,2370847700)
,(2863578545,2370847700)
,(1114087459,2370847700)
,(0735081905,2370847700)
,(6803427978,2370847700)
,(7399678758,2370847700)
,(2371914096,2370847700)
,(0570524512,2370847700)
,(8750805266,2370847700)
,(1969544007,2370847700)
,(0602839920,2370847700)
,(9927795564,2370847700)
,(2453074563,2370847700)
,(5267580848,2370847700)
,(4542540774,2370847700)
,(1886440972,2370847700)
,(6539904754,2370847700)
,(7619206779,2370847700)
,(0555276155,2370847700)
,(7848970159,2370847700)
,(2124854186,2370847700)
,(8171677967,2370847700)
,(7189990739,2370847700)
,(9880512162,2370847700)
,(5769964111,2370847700)
,(9407996514,2370847700)
,(9024427924,2370847700)
,(0525395997,2370847700)
,(5374167723,2370847700)
,(5318305520,2370847700)
,(2081181827,2370847700)
,(7272290781,2370847700)
,(5931307273,2370847700)
,(5979333177,2370847700)
,(2865716600,2370847700)
,(8329426947,2370847700)
,(7198964737,2370847700)
,(8607129104,2370847700)
,(4089129656,2370847700)
,(0226266095,6331731407)
,(8359948771,6331731407)
,(0525262342,6331731407)
,(0701823224,6331731407)
,(0269956336,6331731407)
,(1186139722,6331731407)
,(0216923751,6331731407)
,(8486852218,6331731407)
,(1551848554,6331731407)
,(7092261929,6331731407)
,(2307416080,6331731407)
,(5151476564,6331731407)
,(0578871300,6331731407)
,(6780553107,6331731407)
,(6448345620,6331731407)
,(1474814417,6331731407)
,(6430689107,6331731407)
,(9752927386,6331731407)
,(2519212160,6331731407)
,(1541417453,6331731407)
,(6308943983,6331731407)
,(0066064864,6331731407)
,(2863578545,6331731407)
,(1114087459,6331731407)
,(0735081905,6331731407)
,(6803427978,6331731407)
,(7399678758,6331731407)
,(2371914096,6331731407)
,(0570524512,6331731407)
,(8750805266,6331731407)
,(1969544007,6331731407)
,(0602839920,6331731407)
,(9927795564,6331731407)
,(2453074563,6331731407)
,(5267580848,6331731407)
,(4542540774,6331731407)
,(1886440972,6331731407)
,(6539904754,6331731407)
,(7619206779,6331731407)
,(0555276155,6331731407)
,(7848970159,6331731407)
,(2124854186,6331731407)
,(8171677967,6331731407)
,(7189990739,6331731407)
,(9880512162,6331731407)
,(5769964111,6331731407)
,(9407996514,6331731407)
,(9024427924,6331731407)
,(0525395997,6331731407)
,(5374167723,6331731407)
,(5318305520,6331731407)
,(2081181827,6331731407)
,(7272290781,6331731407)
,(5931307273,6331731407)
,(5979333177,6331731407)
,(2865716600,6331731407)
,(8329426947,6331731407)
,(7198964737,6331731407)
,(8607129104,6331731407)
,(4089129656,6331731407)
,(0226266095,2310291293)
,(8359948771,2310291293)
,(0525262342,2310291293)
,(0701823224,2310291293)
,(0269956336,2310291293)
,(1186139722,2310291293)
,(0216923751,2310291293)
,(8486852218,2310291293)
,(1551848554,2310291293)
,(7092261929,2310291293)
,(2307416080,2310291293)
,(5151476564,2310291293)
,(0578871300,2310291293)
,(6780553107,2310291293)
,(6448345620,2310291293)
,(1474814417,2310291293)
,(6430689107,2310291293)
,(9752927386,2310291293)
,(2519212160,2310291293)
,(1541417453,2310291293)
,(6308943983,2310291293)
,(0066064864,2310291293)
,(2863578545,2310291293)
,(1114087459,2310291293)
,(0735081905,2310291293)
,(6803427978,2310291293)
,(7399678758,2310291293)
,(2371914096,2310291293)
,(0570524512,2310291293)
,(8750805266,2310291293)
,(1969544007,2310291293)
,(0602839920,2310291293)
,(9927795564,2310291293)
,(2453074563,2310291293)
,(5267580848,2310291293)
,(4542540774,2310291293)
,(1886440972,2310291293)
,(6539904754,2310291293)
,(7619206779,2310291293)
,(0555276155,2310291293)
,(7848970159,2310291293)
,(2124854186,2310291293)
,(8171677967,2310291293)
,(7189990739,2310291293)
,(9880512162,2310291293)
,(5769964111,2310291293)
,(9407996514,2310291293)
,(9024427924,2310291293)
,(0525395997,2310291293)
,(5374167723,2310291293)
,(5318305520,2310291293)
,(2081181827,2310291293)
,(7272290781,2310291293)
,(5931307273,2310291293)
,(5979333177,2310291293)
,(2865716600,2310291293)
,(8329426947,2310291293)
,(7198964737,2310291293)
,(8607129104,2310291293)
,(4089129656,2310291293)