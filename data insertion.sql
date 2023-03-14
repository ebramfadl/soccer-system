



--------------------------------------------------------------------------------------------------------------------------

--Club

set identity_insert Club on
insert into Club(club_id,name,location) values (1,'Real Madrid', 'Madrid, España')
insert into Club(club_id,name,location) values(2,'Barcelona', 'Catalonia, España')
insert into Club(club_id,name,location) values (3,'Athletic bilbao', 'Basque, España')
insert into Club(club_id,name,location) values (4,'Athletico Madrid', 'Madrid, España')
insert into Club(club_id,name,location) values (5,'Sevilla',	'Andalusia, España')
insert into Club(club_id,name,location) values (6,'Bayern Munchen', 'Bavaria, Deutschland')
insert into Club(club_id,name,location) values (7,'Borussia Dortmund', 'Dortmund,Deutschland')
insert into Club(club_id,name,location) values (8,'Paris Saint German', 'Paris, France')
insert into Club(club_id,name,location) values (9,'Manchester United', 'Manchester, England')
insert into Club(club_id,name,location) values (10,'Manchester City', 'Manchester, England')
insert into Club(club_id,name,location) values (11,'Liverpool', 'Liverpool, England')
insert into Club(club_id,name,location) values (12,'Chelsea', 'London, England')
insert into Club(club_id,name,location) values (13,'AC Milan', 'Milano, Italia')
insert into Club(club_id,name,location) values (14,'AS Rome',	'Rome, Italia')
insert into Club(club_id,name,location) values (15,'Juventus', 'Turino, Italia')
insert into Club(club_id,name,location) values (16,'Napoli', 'Naples, Italia')
set identity_insert Club off

select * from Club
delete from Club
delete from Match
-----------------------------------------------------------------------------------------------------------------------


--Club Representative

insert into SystemUser values('sergioramos','sergioramos')
insert into SystemUser values('andresinesta','andresinesta')
insert into SystemUser values('unaisimon','unaisimon')
insert into SystemUser values('josemariagimenez','josemariagimenez')
insert into SystemUser values('jesusnavas','jesusnavas')
insert into SystemUser values('thomasmuller','thomasmuller')
insert into SystemUser values('marcoreus','marcoreus')
insert into SystemUser values('kylianmbabe','kylianmbabe')
insert into SystemUser values('marcosrashford','marcosrashford')
insert into SystemUser values('kevindebruyne','kevindebruyne')
insert into SystemUser values('mohamedsalah','mohamedsalah')
insert into SystemUser values('davidluiz','davidluiz')
insert into SystemUser values('andreapirlo','andreapirlo')
insert into SystemUser values('ruipatricio','ruipatricio')
insert into SystemUser values('angeldimaria','angeldimaria')
insert into SystemUser values('marekhamsik','marekhamsik')

set identity_insert ClubRepresentative on
insert into ClubRepresentative(id,club_id,name,username) values (1,1,'Sergio Ramos', 'sergioramos')
insert into ClubRepresentative(id,club_id,name,username) values(2,2,'Andres Inesta', 'andresinesta')
insert into ClubRepresentative(id,club_id,name,username) values (3,3,'Unai Simon', 'unaisimon')
insert into ClubRepresentative(id,club_id,name,username) values (4,4,'Jose Maria Gimenez', 'josemariagimenez')
insert into ClubRepresentative(id,club_id,name,username) values (5,5,'Jesus Navas',	'jesusnavas')
insert into ClubRepresentative(id,club_id,name,username) values (6,6,'Thomas Muller', 'thomasmuller')
insert into ClubRepresentative(id,club_id,name,username) values (7,7,'Marco Reus', 'marcoreus')
insert into ClubRepresentative(id,club_id,name,username) values (8,8,'Kylian Mbabe', 'kylianmbabe')
insert into ClubRepresentative(id,club_id,name,username) values (9,9,'Marcos Rashford', 'marcosrashford')
insert into ClubRepresentative(id,club_id,name,username) values (10,10,'Kevin De Bruyne', 'kevindebruyne')
insert into ClubRepresentative(id,club_id,name,username) values (11,11,'Mohamed Salah', 'mohamedsalah')
insert into ClubRepresentative(id,club_id,name,username) values (12,12,'David Luiz', 'davidluiz')
insert into ClubRepresentative(id,club_id,name,username) values (13,13,'Andrea Pirlo', 'andreapirlo')
insert into ClubRepresentative(id,club_id,name,username) values (14,14,'Rui Patricio',	'ruipatricio')
insert into ClubRepresentative(id,club_id,name,username) values (15,15,'Di Maria', 'angeldimaria')
insert into ClubRepresentative(id,club_id,name,username) values (16,16,'Marek Hamsik', 'marekhamsik')
set identity_insert ClubRepresentative off

select * from ClubRepresentative

---------------------------------------------------------------------------------------------------------------------

--Stadium

set identity_insert Stadium on;
insert into Stadium (stadium_id,name,location,status,capacity) values (1,'Santiago Bernabio','Madrid, España',1,81044);
insert into Stadium (stadium_id,name,location,status,capacity) values (2,'Camp Nou','Catalonia, España',1,99354);
insert into Stadium (stadium_id,name,location,status,capacity) values (3,'San Mames','Basque, España',1,53289);
insert into Stadium (stadium_id,name,location,status,capacity) values (4,'Metropolitano','Madrid, España',1,68456);
insert into Stadium (stadium_id,name,location,status,capacity) values (5,'Ramon SanchezPizjuan','Andalusia, España',1,42714);
insert into Stadium (stadium_id,name,location,status,capacity) values (6,'Allianz Arena','Bavaria, Deutschland',1,75024);
insert into Stadium (stadium_id,name,location,status,capacity) values (7,'Signal Iduna Park','Dortmund, Deutschland',1,81365);
insert into Stadium (stadium_id,name,location,status,capacity) values (8,'Parc des Princes','Paris, France',1,47929);
insert into Stadium (stadium_id,name,location,status,capacity) values (9,'Old Trafford','Manchester, England',1,74310);
insert into Stadium (stadium_id,name,location,status,capacity) values (10,'Etihad Stadium','Manchester, England',1,53400);
insert into Stadium (stadium_id,name,location,status,capacity) values (11,'Anfield','Liverpool, England',1,53394);
insert into Stadium (stadium_id,name,location,status,capacity) values (12,'Stamford Bridge','London, England',1,41837);
insert into Stadium (stadium_id,name,location,status,capacity) values (13,'San Siro','Milano, Italia',1,80018);
insert into Stadium (stadium_id,name,location,status,capacity) values (14,'Stadio Olimpico','Rome, Italia',1,72698);
insert into Stadium (stadium_id,name,location,status,capacity) values (15,'Allianz Stadium','Turino, Italia',1,41507);
insert into Stadium (stadium_id,name,location,status,capacity) values (16,'Maradona Stadium','Naples, Italia',1,54726);
set identity_insert Stadium off;


select * from Stadium

-----------------------------------------------------------------------------------------------------------------------------

--Stadium Manager

insert into SystemUser(username,password) values('ebramfadl','ebramfadl')
insert into SystemUser(username,password) values('janaabubakr','janaabubakr')
insert into SystemUser(username,password) values('arwagad','arwagad')
insert into SystemUser(username,password) values('nourashraf','nourashraf')
insert into SystemUser(username,password) values('jorgesampaoli','jorgesampaoli')
insert into SystemUser(username,password) values('jurgenklub','jurgenklub')
insert into SystemUser(username,password) values('luisenrique','luisenrique')
insert into SystemUser(username,password) values('zinedinezidane','zinedinezidane')
insert into SystemUser(username,password) values('siralexvergson','siralexvergson')
insert into SystemUser(username,password) values('pepeguardiola','pepeguardiola')
insert into SystemUser(username,password) values('josemurinio','josemurinio')
insert into SystemUser(username,password) values('antoniokonte','antoniokonte')
insert into SystemUser(username,password) values('gattuso','gattuso')
insert into SystemUser(username,password) values('derossi','derossi')
insert into SystemUser(username,password) values('diegosimeone','diegosimeone')
insert into SystemUser(username,password) values('carloancelotti','carloancelotti')


set identity_insert StadiumManager on
insert into StadiumManager(id,name,username,stadium_id) values(1,'Ebram Fadl','ebramfadl',1)
insert into StadiumManager(id,name,username,stadium_id) values(2,'Jana Abubakr','janaabubakr',2)
insert into StadiumManager(id,name,username,stadium_id) values(3,'Arwa Gad','arwagad',3)
insert into StadiumManager(id,name,username,stadium_id) values(4,'Nour Ashraf','nourashraf',4)
insert into StadiumManager(id,name,username,stadium_id) values(5,'Jorge Sampaoli','jorgesampaoli',5)
insert into StadiumManager(id,name,username,stadium_id) values(6,'Jurgen Klub','jurgenklub',6)
insert into StadiumManager(id,name,username,stadium_id) values(7,'Luis Enrique','luisenrique',7)
insert into StadiumManager(id,name,username,stadium_id) values(8,'Zinedine Zidane','zinedinezidane',8)
insert into StadiumManager(id,name,username,stadium_id) values(9,'Sir Alex Vergson','siralexvergson',9)
insert into StadiumManager(id,name,username,stadium_id) values(10,'Pepe Guardiola','pepeguardiola',10)
insert into StadiumManager(id,name,username,stadium_id) values(11,'Jose Murinio','josemurinio',11)
insert into StadiumManager(id,name,username,stadium_id) values(12,'Antonio Konte','antoniokonte',12)
insert into StadiumManager(id,name,username,stadium_id) values(13,'Gattuso','gattuso',13)
insert into StadiumManager(id,name,username,stadium_id) values(14,'De Rossi','derossi',14)
insert into StadiumManager(id,name,username,stadium_id) values(15,'Diego Simeone','diegosimeone',15)
insert into StadiumManager(id,name,username,stadium_id) values(16,'Carlo Ancelotti','carloancelotti',16)
set identity_insert StadiumManager off

select * from StadiumManager

----------------------------------------------------------------------------------------------------------------------

--Fan

insert into SystemUser(username,password) values('omar','omar')
insert into SystemUser(username,password) values('ahmed','ahmed')
insert into SystemUser(username,password) values('peter','peter')
insert into SystemUser(username,password) values('mohamed','mohamed')
insert into SystemUser(username,password) values('abdallah','abdallah')
insert into SystemUser(username,password) values('tareq','tareq')
insert into SystemUser(username,password) values('mostafa','mostafa')
insert into SystemUser(username,password) values('daniel','daniel')
insert into SystemUser(username,password) values('amr','amr')
insert into SystemUser(username,password) values('abdulrahman','abdulrahman')
insert into SystemUser(username,password) values('ali','ali')
insert into SystemUser(username,password) values('david','david')
insert into SystemUser(username,password) values('mathew','mathew')
insert into SystemUser(username,password) values('andrew','andrew')
insert into SystemUser(username,password) values('philipe','philipe')



insert into Fan(username,name,national_id,status,address,phone_number,birth_date) values('omar','omar',501,1,'whatever','12324610','1/10/2001')
insert into Fan(username,name,national_id,status,address,phone_number,birth_date)values('ahmed','ahmed',502,1,'whatever','12324620','2/20/2002')
insert into Fan(username,name,national_id,status,address,phone_number,birth_date)values('peter','peter',503,1,'whatever','12324630','4/2/2003')
insert into Fan(username,name,national_id,status,address,phone_number,birth_date)values('mohamed','mohamed',504,1,'whatever','12324640','5/12/2004')
insert into Fan(username,name,national_id,status,address,phone_number,birth_date)values('abdallah','abdallah',505,1,'whatever','12324650','6/22/2005')
insert into Fan(username,name,national_id,status,address,phone_number,birth_date)values('tareq','tareq',506,1,'whatever','12324660','8/2/2006')
insert into Fan(username,name,national_id,status,address,phone_number,birth_date)values('mostafa','mostafa',507,1,'whatever','12324670','9/12/2007')
insert into Fan(username,name,national_id,status,address,phone_number,birth_date)values('daniel','daniel',508,1,'whatever','12324680','10/22/2008')
insert into Fan(username,name,national_id,status,address,phone_number,birth_date)values('amr','amr',509,1,'whatever','12324690','12/2/2009')
insert into Fan(username,name,national_id,status,address,phone_number,birth_date)values('abdulrahman','abdulrahman',510,1,'whatever','12324700','1/12/2011')
insert into Fan(username,name,national_id,status,address,phone_number,birth_date)values('ali','ali',511,1,'whatever','12324710','2/22/2012')
insert into Fan(username,name,national_id,status,address,phone_number,birth_date)values('david','david',512,1,'whatever','12324720','4/3/2013')
insert into Fan(username,name,national_id,status,address,phone_number,birth_date)values('mathew','mathew',513,1,'whatever','12324730','5/14/2014')
insert into Fan(username,name,national_id,status,address,phone_number,birth_date)values('andrew','andrew',514,1,'whatever','12324740','6/24/2015')
insert into Fan(username,name,national_id,status,address,phone_number,birth_date)values('philipe','philipe',515,1,'whatever','12324750','8/3/2016')

select * from Fan

-----------------------------------------------------------------------------------------------------------------------
