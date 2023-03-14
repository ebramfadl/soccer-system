

create database Soccer

use soccer
go

CREATE PROC createAllTables
AS 
BEGIN
	CREATE TABLE SystemUser (
		username VARCHAR(20)  PRIMARY KEY,
		password VARCHAR(20) NOT NULL
	);

	CREATE TABLE Fan(
		national_id varchar(20) PRIMARY KEY,
		name VARCHAR(20),
		status BIT,
		address VARCHAR(20),
		username VARCHAR(20) FOREIGN KEY REFERENCES SystemUser ON UPDATE CASCADE ON DELETE CASCADE,
		phone_number VARCHAR(20),
		birth_date DATETIME
	);

	CREATE TABLE SportsAssociationManager (
		id INT PRIMARY KEY IDENTITY(1,1),
		name VARCHAR(20),
		username VARCHAR(20) FOREIGN KEY REFERENCES SystemUser ON UPDATE CASCADE ON DELETE CASCADE
	);

	CREATE TABLE SystemAdmin (
		id INT PRIMARY KEY IDENTITY(1,1),
		name VARCHAR(20),
		username VARCHAR(20) FOREIGN KEY REFERENCES SystemUser ON UPDATE CASCADE ON DELETE CASCADE
	);

	CREATE TABLE Stadium (
		stadium_id INT PRIMARY KEY IDENTITY(1,1),
		name VARCHAR(20),
		location VARCHAR(20),
		status BIT,
		capacity INT
	);

	CREATE TABLE StadiumManager(
		id INT PRIMARY KEY IDENTITY(1,1),
		name VARCHAR(20),
		username VARCHAR(20) FOREIGN KEY REFERENCES SystemUser ON UPDATE CASCADE ON DELETE CASCADE,
		stadium_id INT FOREIGN KEY  REFERENCES Stadium ON UPDATE CASCADE ON DELETE CASCADE
	);

	CREATE TABLE Club(
		club_id int PRIMARY KEY IDENTITY(1,1),
		name VARCHAR(20),
		location VARCHAR(20)
	);

	CREATE TABLE ClubRepresentative(
		id INT PRIMARY KEY IDENTITY(1,1),
		name VARCHAR(20),
		username VARCHAR(20) FOREIGN KEY REFERENCES SystemUser ON UPDATE CASCADE ON DELETE CASCADE,
		club_id INT FOREIGN KEY  REFERENCES Club ON UPDATE CASCADE ON DELETE CASCADE
	);

	CREATE TABLE Match(
		match_id INT PRIMARY KEY IDENTITY(1,1),
		start_time DATETIME,
		end_time DATETIME,
		stadium_id int FOREIGN KEY REFERENCES Stadium ,
		host_club_id int FOREIGN KEY REFERENCES Club ,
		guest_club_id int FOREIGN KEY REFERENCES Club 
	);

	CREATE TABLE HostRequest(
		request_id INT PRIMARY KEY IDENTITY(1,1),
		match_id INT FOREIGN KEY REFERENCES Match ,
		status BIT,
		representative_id INT FOREIGN KEY REFERENCES ClubRepresentative,
		manager_id INT FOREIGN KEY REFERENCES  StadiumManager 
	);

	CREATE TABLE Ticket(
		ticket_id INT PRIMARY KEY IDENTITY(1,1),
		status BIT,
		fan_id  varchar(20) FOREIGN KEY REFERENCES Fan ON UPDATE CASCADE ON DELETE CASCADE,
		match_id  INT FOREIGN KEY REFERENCES Match ON UPDATE CASCADE ON DELETE CASCADE
	);

END




GO;
CREATE PROC dropAllTables
AS
BEGIN 
	DROP TABLE Ticket
	DROP TABLE HostRequest
	DROP TABLE Match
	DROP TABLE ClubRepresentative
	DROP TABLE Club
	DROP TABLE StadiumManager
	DROP TABLE Stadium
	DROP TABLE SystemAdmin
	DROP TABLE SportsAssociationManager
	DROP TABLE Fan
	DROP TABLE SystemUser
END




go;
CREATE PROC dropAllProceduresFunctionsViews
AS
BEGIN
	drop proc createAllTables
	drop proc dropAllTables
	drop proc clearAllTables
	drop proc addAssociationManager
	drop proc addNewMatch
	drop proc deleteMatch
	drop proc deleteMatchesOnStadium
	drop proc addClub
	drop proc addTicket
	drop proc deleteClub
	drop proc addStadium
	drop proc deleteStadium
	drop proc blockFan
	drop proc unblockFan
	drop proc addRepresentative
	drop proc addHostRequest
	drop proc addStadiumManager
	drop proc acceptRequest
	drop proc rejectRequest
	drop proc addFan
	drop proc purchaseTicket
	drop proc updateMatchHost
	drop proc addRepresentative


	drop view allAssocManagers
	drop view allClubRepresentatives
	drop view allStadiumManagers
	drop view allFans
	drop view allMatches
	drop view allTickets
	drop view allCLubs
	drop view allStadiums
	drop view allRequests
	drop view clubsWithNoMatches
	drop view matchesPerTeam
	drop view clubsNeverMatched


	drop function viewAvailableStadiumsOn
	drop function allUnassignedMatches
	drop function allPendingRequests
	drop function upcomingMatchesOfClub
	drop function availableMatchesToAttend
	drop function clubsNeverPlayed
	drop function matchWithHighestAttendance
	drop function matchesRankedByAttendance
	drop function requestsFromClub
	
END



GO;
CREATE PROC clearAllTables
AS
BEGIN 
	delete from Ticket
	delete from HostRequest
	delete from Match
	delete from ClubRepresentative
	delete from Club
	delete from StadiumManager
	delete from Stadium
	delete from SystemAdmin
	delete from SportsAssociationManager
	delete from Fan
	delete from SystemUser
END

GO;
CREATE VIEW allAssocManagers
AS
	SELECT MG.username,U.password,name
	FROM SportsAssociationManager MG 
	inner join SystemUser U on U.username = MG.username




go;
CREATE VIEW allClubRepresentatives
AS
	SELECT CR.username,U.password,CR.name,C.name AS clubName
	FROM ClubRepresentative CR
	INNER JOIN Club C on CR.club_id=C.club_id
	inner join SystemUser U on U.username = CR.username




go
CREATE VIEW allStadiumManagers
AS
	SELECT SM.username,U.password,SM.name,S.name AS StadiumName
	FROM StadiumManager SM
	INNER JOIN Stadium S on S.stadium_id=SM.id
	inner join SystemUser U on U.username = SM.username;




GO;
CREATE VIEW allFans
AS
	SELECT F.username,U.password,F.name,F.national_id,F.birth_date,F.status
	FROM Fan F
	inner join SystemUser U on U.username = F.username




GO;
CREATE VIEW allMatches
AS
	SELECT C1.name "Host Club",C2.name "Guest Club",M.start_time
	FROM Match M
	inner join Club C1 on M.host_club_id=C1.club_id 
	inner join Club C2 on M.guest_club_id=C2.club_id



go;
CREATE VIEW allTickets
AS
	SELECT C1.name "Host Club",C2.name "Guest Club" , S1.name "Host stadium" ,M.start_time 
	FROM Ticket T
	inner join Match  M on M.match_id=T.match_id 
	inner join Club C1 on M.host_club_id=C1.club_id 
	inner join Club C2 on M.guest_club_id=C2.club_id
	inner join Stadium S1 on S1.stadium_id=M.stadium_id



go;
CREATE VIEW allCLubs
AS
	SELECT name,location
	FROM Club



go;
CREATE VIEW allStadiums
AS
	SELECT name,location, capacity,status
	FROM Stadium




go;
CREATE VIEW allRequests
AS
	SELECT CR.username "Club Representative Username",SM.username "Stadium Manager Username",HR.status 
	FROM HostRequest HR
	INNER JOIN ClubRepresentative CR on CR.id=HR.representative_id
	INNER JOIN StadiumManager SM on SM.id=HR.manager_id




go
create proc adminLogin
	@username varchar(20),
	@password varchar(20),
	@result int output
as
begin
	
	if exists( select * from SystemAdmin where username = @username)
	begin
		if exists (select * from SystemUser where username = @username and password = @password)
			set @result = 1
		else
			set @result = 0
	end
end


go
create proc sportAssociacionLogin
	@username varchar(20),
	@password varchar(20),
	@result int output
as
begin
	
	if exists( select * from SportsAssociationManager where username = @username)
	begin
		if exists (select * from SystemUser where username = @username and password = @password)
			set @result = 1
		else
			set @result = 0
	end
end




--type: stored procedure
--name: addAssociationManager
--input: varchar(20) representing a name , varchar(20) representing a user name ,varchar(20) representing
--a password
--output: nothing
--description: Adds a new association manager with the given information .
go;
create proc addAssociationManager
	@manager_name varchar(20),
	@username varchar(20),
	@password varchar(20),
	@result int output
as
begin
	if not exists (select * from SystemUser where username = @username)
	begin
		insert into SystemUser(username,password) values(@username,@password)
		insert into SportsAssociationManager(username,name) values(@username,@manager_name)
		set @result = 1
	end
	else
		set @result = 0
	
end


select * from SportsAssociationManager
--type: stored procedure
--name: addNewMatch
--input: varchar(20) representing the name of the host club , varchar(20) representing the name of
--the guest club, datetime representing the start time of the match and datetime representing the
--end time of the match
--output: nothing
--description: Adds a new match with the given information.
go;
create proc addNewMatch
	@host_name varchar(20),
	@guest_name varchar(20),
	@start_time datetime,
	@end_time datetime
as
begin
	declare @guest_id int
	declare @host_id int
	select @host_id = club_id from Club where name = @host_name
	select @guest_id = club_id from Club where name = @guest_name

	if(@host_id is not null and @guest_id is not null)
	begin
		insert into Match(start_time,end_time,stadium_id,host_club_id,guest_club_id)
		values(@start_time,@end_time,null,@host_id,@guest_id);
	end
	else
		print('Incorrect inputs')
end




--type: view
--name: clubsWithNoMatches
--description: Fetches the names of all clubs who were not assigned to any match.
go;
create view clubsWithNoMatches
as
	select C.name from Club C
	where not exists((select * from Match M inner join Club C1 on M.guest_club_id = C1.club_id where C.club_id = C1.club_id) 
	union (select * from Match M1 inner join Club C2 on M1.host_club_id = C2.club_id where C.club_id = C2.club_id)) 
		



--type: stored procedure
--name: deleteMatch
--input: varchar(20) representing a the name of the host club and varchar(20) representing the name
--of the guest club
--output: nothing
--description: Deletes the match with the given information.
go;
create proc deleteMatch
	@host_name varchar(20),
	@guest_name varchar(20),
	@start_time datetime,
	@result int output
as
begin
	declare @guest_id int
	declare @host_id int
	declare @match_id int
	select @host_id = club_id from Club where name = @host_name
	select @guest_id = club_id from Club where name = @guest_name
	select @match_id = match_id from Match where host_club_id = @host_id and guest_club_id = @guest_id and start_time = @start_time;

	if exists (select * from Match where match_id = @match_id)
	begin
		delete from Match where match_id = @match_id
		set @result = 1
	end
	else
		set @result = 0

	--Note: when deleteing match delete it's corresponding tickets
	--delete from Ticket where match_id = @match_id
end



--type: stored procedure
--name: deleteMatchesOnStadium
--input: varchar(20) representing a name of a stadium
--output: nothing
--description: Deletes all matches that will be played on a stadium with the given name. The
--matches that have already been played on that stadium should be kept not deleted.
go;
create proc deleteMatchesOnStadium
	@stadium_name varchar(20)
as
begin
	declare @stadium_id int
	select @stadium_id = stadium_id from Stadium where name = @stadium_name
	
	delete from Match where @stadium_id = stadium_id and start_time > CURRENT_TIMESTAMP
	

	--Note : we also need to delete tickets on that stadium 
	--delete from Ticket where match_id in (select match_id from Match M 
	--inner join Stadium S on M.stadium_id = S.stadium_id 
	--where S.stadium_id = @stadium_id)
	
end




--type: stored procedure
--name: addClub
--input: varchar(20) representing a name of a club, varchar(20) representing a location of a club
--output: nothing
--description: Adds a new club with the given information.
go;
create proc addClub
	@club_name varchar(20),
	@location  varchar(20)
as
begin
	if not exists (select * from Club where name= @club_name)
	begin
		insert into Club(name,location) values(@club_name,@location)
	end
	else
		print('Club exists already!')
end




--type: stored procedure
--name: addTicket
--input: varchar(20) representing the name of the host club, varchar(20) representing the name of
--the guest club, datetime representing the start time of the match
go;
create proc addTicket
	@host_name varchar(20),
	@guest_name varchar(20),
	@start_time datetime
as
begin
	declare @guest_id int
	declare @host_id int
	declare @match_id int

	select @host_id = club_id from Club where name = @host_name
	select @guest_id = club_id from Club where name = @guest_name
	select @match_id = match_id from Match where host_club_id = @host_id and guest_club_id = @guest_id and start_time = @start_time

	if(@host_id is not null and @guest_id is not null)
		insert into Ticket (match_id,status) values (@match_id,1);
	else
		print('Invalid inputs for club names')
	
end




--type: stored procedure
--name: deleteClub
--input: varchar(20) representing a name of a club,
--output: nothing
--description: Deletes the club with the given name.
--output: nothing
--description: Adds a new ticket belonging to a match with the given information.
go;
create proc deleteClub
	@club_name varchar(20),
	@result int output
as
begin
	declare @club_id int
	select @club_id = club_id from Club where name = @club_name

	if exists(select * from Club where club_id = @club_id)
	begin
		delete from Match where host_club_id = @club_id or guest_club_id = @club_id
		delete from Club where club_id = @club_id
		set @result = 1
	end
	else
		set @result = 0
end



--type: stored procedure
--name: addStadium
--input: varchar(20) representing a name of a stadium, varchar(20) representing a location of a
--stadium, int representing a capacity of a stadium
--output: nothing
--description: Adds a new stadium with the given information.
go;
create proc addStadium
	@stadium_name varchar(20),
	@location varchar(20),
	@capacity int,
	@result int output
as
begin
	if not exists (select * from Stadium where name= @stadium_name)
	begin
		insert into Stadium(name,location,capacity,status) values (@stadium_name,@location,@capacity,1)
		set @result = 1
	end
	else
		set @result = 0
end

select * from Stadium

--type: stored procedure
--name: deleteStadium
--input: varchar(20) representing a name of a stadium
--output: nothing
--description: Deletes stadium with the given name.
go;
create proc deleteStadium
	@stadium_name varchar(20),
	@result int output
as
begin
	declare @stadium_id int
	select @stadium_id = stadium_id from Stadium where name = @stadium_name

	--Do we need to remove it's corresponding HostRequest
	if (@stadium_id is not null)
	begin
		delete from Match where stadium_id = @stadium_id
		delete from Stadium where name = @stadium_name
		set @result = 1
	end
	else
		set @result = 0
end


select * from Match
--type: stored procedure
--name: blockFan
--input: varchar(20) representing a national id number of a fan
--output: nothing
--description: blocks the fan with the given national id number.
go;
create proc blockFan
	@national_id varchar(20),
	@result int output
	--@name varchar(20) output
as
begin
	--declare @fanName varchar(20)
	--select @fanName = name from Fan where national_id = @national_id

	if exists (select * from Fan where national_id = @national_id)
	begin
		update Fan set status = 0 where national_id = @national_id
		--set @name = @fanName 
		set @result = 1
	end
	else
	begin
		--set @name = ''
		set @result = 0
	end
end

select * from Fan

--type: stored procedure
--name: unblockFan
--input: varchar(20) representing a national id number of a fan
--output: nothing
--description: Unblocks the fan with the given national id number.
go;
create proc unblockFan
	@national_id varchar(20)
as
begin
	update Fan set status = 1 where national_id = @national_id
end




--type: stored procedure
--name: addRepresentative
--input: varchar(20) representing a name ,varchar(20) representing a club name, varchar(20) representing
--a user name ,varchar(20) representing a password
--output: nothing
--description: Adds a new club representative with the given information .
go;
create proc addRepresentative
	@rep_name varchar(20),
	@club_name varchar(20),
	@username varchar(20),
	@password varchar(20)
as
begin
	declare @club_id int
	select @club_id = club_id from Club where name = @club_name

	if not exists (select * from ClubRepresentative where club_id = @club_id)
	begin
		insert into SystemUser(username,password) values (@username,@password)
		insert into ClubRepresentative(name,club_id,username) values (@rep_name,@club_id,@username)
	end
	else
		print('Representative exists already!')
end




--type: function
--name: viewAvailableStadiumsOn
--input: datetime
--output: table
--description: returns a table containing the name, location and capacity of all stadiums which are
--available for reservation and not already hosting a match on the given date.
go;
create function viewAvailableStadiumsOn ( @date datetime) returns table
as
return
	select S.name,S.location,S.capacity from Stadium S where status = 1 and not exists (
		select * from Stadium S1 inner join Match M on S1.stadium_id = M.stadium_id and M.start_time = @date and S1.stadium_id = S.stadium_id
	);  




--type: stored procedure
--name: addHostRequest
--input: varchar(20) representing club name ,varchar(20) representing a stadium name, datetime
--representing the starting time of a match
--output: nothing
--description: Adds a new request sent from the representative of the given club to the representative
--of the given stadium regarding the match starting at the given time which the given club is assigned
--to host.
go;
create proc addHostRequest
	@club_name varchar(20),
	@stadium_name varchar(20),
	@start_time datetime
as
begin
	declare @club_id int
	declare @stadium_id int
	declare @match_id int
	declare @manager_id int
	declare @rep_id int

	select @club_id = club_id from Club where name = @club_name
	select @stadium_id = stadium_id from Stadium where name = @stadium_name
	select @match_id = match_id from Match where stadium_id = @stadium_id and start_time = @start_time and @club_id = host_club_id
	select @rep_id = id from ClubRepresentative where club_id = @club_id
	select @manager_id = id from StadiumManager where stadium_id = @stadium_id

		
	if(@club_id is not null and @manager_id is not null)
	--Note: the status of the host request is initially null
	insert into HostRequest (match_id,representative_id,manager_id,status) values (@match_id,@rep_id,@manager_id,null)

end




--type: function
--name: allUnassignedMatches
--input: varchar(20) representing the name of a club
--output: table
--description: returns a table containing the info of the matches that are being hosted by the given
--club but have not been assigned to a stadium yet. The info should be the name of the guest club
--and the start time of the match.
go;
create function allUnassignedMatches (@club_name varchar(20)) returns table
as
return

	select G.name as 'Guest Club', M.start_time from Match M
	inner join Club H on M.host_club_id = H.club_id
	inner join Club G on M.guest_club_id = G.club_id
	where H.name = @club_name and M.stadium_id is null



--type: stored procedure
--name: addStadiumManager
--input: varchar(20) representing a name ,varchar(20) representing a stadium name, varchar(20)
--representing a user name ,varchar(20) representing a password
go;
create proc addStadiumManager
	@manager_name varchar(20),
	@stadium_name varchar(20),
	@username varchar(20),
	@password varchar(20)
as
begin
	declare @stadium_id int
	select @stadium_id = stadium_id from Stadium where name = @stadium_name

	if not exists (select * from StadiumManager MG where MG.stadium_id = @stadium_id)
	begin
		insert into SystemUser(username,password) values (@username,@password)
		insert into StadiumManager(name,stadium_id,username) values (@manager_name,@stadium_id,@username)
	end
	else
		print('Manager exists already!')
end




--type: function
--name: allPendingRequests
--input: varchar(20) representing the username of a stadium manager
--output: table
--description: returns a table containing the info of the requests that the given stadium manager
--has yet to respond to. The info should be name of the club Representative sending the request,
--name of the guest club competing with the sender and the start time of the match requested to be
--hosted.
GO;
create function allPendingRequests ( @username varchar(20) ) returns table
as
return 
	select CR.name AS 'Representative Name' , C.name AS 'Guest Club Name' , M.start_time from StadiumManager SM 
	inner join HostRequest HR on SM.id = HR.manager_id
	inner join ClubRepresentative CR on CR.id = HR.representative_id
	inner join Match M on M.match_id = HR.match_id
	inner join Club C on C.club_id = M.guest_club_id
	where SM.username = @username and HR.status is null




--type: stored procedure
--name: acceptRequest
--input: varchar(20) representing a username of a stadium manager ,varchar(20) representing hosting
--club name ,varchar(20) representing a guest club name, datetime representing the start time of a
--match
--output: nothing
--description: Accepts the already sent request with the given info.
go;
create proc acceptRequest
	@username varchar(20),
	@host_club_name varchar(20),
	@guest_club_name varchar(20),
	@match_time datetime
as
begin
	declare @manager_id int
	declare @host_id int
	declare @guest_id int 
	declare @representative_id int
	declare @match_id int
	declare @stadium_id int

	select @manager_id = id from StadiumManager where username = @username
	select @host_id = club_id from Club where name = @host_club_name
	select @guest_id = club_id from Club where name = @guest_club_name
	select @representative_id = id from ClubRepresentative where club_id = @host_id
	select @match_id = HR.match_id from HostRequest HR inner join Match M on HR.match_id = M.match_id
	where HR.representative_id = @representative_id and HR.manager_id = @manager_id and
	start_time = @match_time
	select @stadium_id = stadium_id from StadiumManager where id = @manager_id

	update HostRequest 
	set status = 1 where match_id = @match_id and representative_id = @representative_id and
	manager_id = @manager_id 

	update Match
	set stadium_id = @stadium_id where match_id = @match_id

	declare @stad_capacity int
	declare @num_of_tickets int
	set @num_of_tickets = 1
	--start by 1 not 0
	select @stad_capacity = capacity from Stadium where stadium_id = @stadium_id
	
	while(@num_of_tickets <= @stad_capacity)
	begin
		insert into Ticket (status,match_id) values(1,@match_id)
		set @num_of_tickets = @num_of_tickets + 1
	end
end





--type: stored procedure
--name: rejectRequest
--input: varchar(20) representing a username of a stadium manager ,varchar(20) representing hosting
--club name ,varchar(20) representing a guest club name, datetime representing the start time of a
--match
--description: Rejects the already sent request with the given info.
go;
create proc rejectRequest

	@username varchar(20),
	@host_club_name varchar(20),
	@guest_club_name varchar(20),
	@match_time datetime
as
begin
	declare @manager_id int
	declare @host_id int
	declare @guest_id int 
	declare @representative_id int
	declare @match_id int
	declare @stadium_id int

	select @manager_id = id from StadiumManager where username = @username
	select @host_id = club_id from Club where name = @host_club_name
	select @guest_id = club_id from Club where name = @guest_club_name
	select @representative_id = id from ClubRepresentative where club_id = @host_id
	select @match_id = HR.match_id from HostRequest HR inner join Match M on HR.match_id = M.match_id
	where HR.representative_id = @representative_id and HR.manager_id = @manager_id and
	start_time = @match_time
	select @stadium_id = stadium_id from StadiumManager where id = @manager_id

	update HostRequest 
	set status = 0 where match_id = @match_id and representative_id = @representative_id and
	manager_id = @manager_id 
end




--type: stored procedure
--name: addFan
--input: varchar(20) representing a name ,varchar(20) representing a national id number, datetime
--representing birth date,varchar(20) representing an address and int representing a phone number
--output: nothing
--description: Adds a new fan with the given information .
go;
create proc addFan
	@name varchar(20),
	@national_id_number varchar(20),
	@birth_date datetime,
	@address varchar(20),
	@phone_number int,
	@username varchar(20),
	@password varchar(20),
	@result int output
as 
begin
	
	if (not exists(select * from Fan where national_id = @national_id_number)) and (not exists(select * from SystemUser where username = @username))
	begin
		insert into Fan (name,national_id,birth_date,address,phone_number,status) values(@name,@national_id_number,@birth_date, 
		@address, @phone_number,1)
		insert into SystemUser(username,password) values(@username,@password)
		set @result = 1
	--make status 1 initially
	end
	else
		set @result = 0
end




--type: function
--name: upcomingMatchesOfClub
--input: varchar(20) representing a club name
--output: table
--description: returns a table containing the info of upcoming matches which the given club will
--play. All already played matches should not be included. The info should be the given club name,
--the competing club name , the starting time of the match and the name of the stadium hosting the
--match.
go
create view allComingMatches
as
	select H.name as 'hostName', G.name as 'guestName',M.start_time as 'starts',M.end_time as 'ends' from Match M
	inner join Club H on M.host_club_id = H.club_id
	inner join Club G on M.guest_club_id = G.club_id
	where M.start_time > CURRENT_TIMESTAMP 

go
create view allPlayedMatches
as
	select H.name as 'hostName', G.name as 'guestName',M.start_time as 'starts',M.end_time as 'ends' from Match M
	inner join Club H on M.host_club_id = H.club_id
	inner join Club G on M.guest_club_id = G.club_id
	where M.start_time < CURRENT_TIMESTAMP 

go;
create function upcomingMatchesOfClub (@club_name varchar(20)) returns table
as
return 
	(select C.name "Given Club", C2.name "Competing Club", M.start_time, S.name from Club C
	inner join Match M on C.club_id = M.host_club_id
	inner join Club C2 on C2.club_id = M.guest_club_id
	left outer join Stadium S on S.stadium_id = M.stadium_id
	where M.start_time > current_timestamp and C.name = @club_name)
	UNION 
	(select C.name "Given Club", C2.name "Competing Club", M2.start_time, S.name from Club C
	inner join Match M2 on C.club_id = M2.guest_club_id
	inner join Club C2 on C2.club_id = M2.host_club_id
	left outer join Stadium S on S.stadium_id = M2.stadium_id
	where M2.start_time > current_timestamp and C.name = @club_name)




--name: availableMatchesToAttend
--input: datetime
--output: table
--description: returns a table containing the info of all upcoming matches which will be played
--starting from the given date and still have tickets available on sale. The info should be the host
--club name, the guest club name , the start time of the match and the name of the stadium hosting
--the match.
go;
create function availableMatchesToAttend (@date datetime) returns table
as
return 
	select C2.name "Host Club", C1.name "Guest Club" ,M.start_time, S.name from Match M
	inner join Ticket T on T.match_id = M.match_id
	inner join Club C1 on C1.club_id = M.guest_club_id
	inner join Club C2 on C2.club_id = M.host_club_id
	inner join Stadium S on S.stadium_id = M.stadium_id
	where M.start_time >= @date and T.status = 1




--type: stored procedure
--name: purchaseTicket
--input: varchar(20) representing the national id number of a fan,varchar(20) representing hosting
--club name ,varchar(20) representing the guest club name, datetime representing the start time of
--the match
--output: nothing
--description: Executes the action of a fan with the given national id number buying a ticket for
--the match with the given info .
go;
create proc purchaseTicket
	@national_id varchar(20),
	@host_club_name varchar(20),
	@guest_club_name varchar(20),
	@start_time datetime
as
begin
	declare @host_club_id int
	declare @guest_club_id int
	declare @match_id int
	declare @ticket_id int

	select @host_club_id = club_id from Club where name = @host_club_name
	select @guest_club_id = club_id from Club where name = @guest_club_name
	select @match_id = match_id from Match where 
	guest_club_id = @guest_club_id and host_club_id = @host_club_id and start_time = @start_time
	select top 1 @ticket_id =  ticket_id  from Ticket where match_id = @match_id and status = 1


	declare @fan_status bit
	select @fan_status = status from Fan where national_id = @national_id


	--Note: cannot purchase a ticket if the fan is blocked
	if(@fan_status = 1)
	begin
		if exists( select * from Ticket where status = 1 and match_id = @match_id)
		begin
			update Ticket
			set status = 0, fan_id = @national_id where ticket_id = @ticket_id
		end
		else
			print('No tickets available to purchase')
	end
	else
		print('Fan is blocked, thus cannot purchase a ticket')
end




--type: stored procedure
--name: updateMatchHost
--input: varchar(20) representing host lub name ,varchar(20) representing guest club name, datetime
--representing the start time of the match
--output: nothing
--description: Change the host of the given match to the guest club .
go;
create proc updateMatchHost
	@host_club_name varchar(20),
	@guest_club_name varchar(20),
	@start_time datetime
as
begin 
	declare @host_club_id int
	declare @guest_club_id int
	declare @match_id int

	select @host_club_id = club_id from club where name=@host_club_name
	select @guest_club_id = club_id from club where name=@guest_club_name
	select @match_id=match_id from Match where host_club_id=@host_club_id and guest_club_id=@guest_club_id and start_time=@start_time
	update Match 
		set host_club_id= @guest_club_id , guest_club_id =@host_club_id where match_id=@match_id
end	




--type: view
--name: matchesPerTeam
--description: Fetches all club names and the number of matches they have already played.
go;
create view matchesPerTeam
AS
	select C.name, count(M.match_id) as 'Total number of matches' from Club C
	left outer join Match M on M.guest_club_id = C.club_id or M.host_club_id = C.club_id
	where M.start_time < CURRENT_TIMESTAMP
	group by C.name;


	

--type: view
--name: clubsNeverMatched
--description: Fetches pair of club names (first club name and second club name) which have never
--played against each other.
go;
create view clubsNeverMatched
AS

	select C1.name "firstClub",C2.name "secondClub"
	from Club C1 , Club C2
	where not exists (
		select * 
		from Match M 
		inner join Club H ON M.host_club_id=H.club_id
		inner join Club G ON M.guest_club_id=G.club_id
		where C1.club_id=H.club_id and C2.club_id=G.club_id 
	) and C1.club_id <> C2.club_id and C1.club_id < C2.club_id
	--Note: C1.club_id <> C2.club_id in order not to have club with itself
	--Note: C1.club_id < C2.club_id in order not to have duplicate records



--type: function
--name: clubsNeverPlayed
--input: varchar(20) representing club name,
--output: table
--description: returns a table containing all club names which the given club has never competed
--against.
GO;
create function clubsNeverPlayed (@club_name VARCHAR(20)) returns table 
AS
return
	
	select G.name from Club G
	where not exists(
		select * from Club C1
		inner join Match M on C1.club_id = M.host_club_id 
		inner join Club C2 on C2.club_id = M.guest_club_id 
		where G.name <> @club_name and C1.club_id <> C2.club_id and (G.name = @club_name or C2.name = @club_name) and M.start_time < CURRENT_TIMESTAMP and G.club_id = C2.club_id
	) and G.name <> @club_name
	union
	select G.name from Club G
	where not exists(
		select * from Club C1
		inner join Match M on C1.club_id = M.guest_club_id 
		inner join Club C2 on C2.club_id = M.host_club_id 
		where G.name <> @club_name and C1.club_id <> C2.club_id and (C1.name = @club_name or C2.name = @club_name) and M.start_time < CURRENT_TIMESTAMP and G.club_id = C1.club_id
	) 




--type: function
--name: matchWithHighestAttendance
--input: nothing
--output: table
--description: returns a table containing the name of the host club and the name of the guest club
--of the match which sold the highest number of tickets so far.
GO;	
create function matchWithHighestAttendance() returns table
as
return
	(
	select C1.name "Host Name", C2.name "Guest Name", count(T.ticket_id) "number of tickets" from Match M
	inner join Club C1 on M.host_club_id = C1.club_id
	inner join Club C2 on M.guest_club_id = C2.club_id
	inner join Ticket T on M.match_id = T.match_id
	where T.status = 0
	group by M.match_id,C1.name,C2.name
	having count(T.ticket_id) > all (select count(T1.ticket_id) from Ticket T1
	where T1.status = 0 and T1.match_id <> M.match_id group by T1.match_id )
	)




--type: function
--name: matchesRankedByAttendance
--input: nothing
--output: table
--description: returns a table containing the name of the host club and the name of the guest club
--of all played matches sorted descendingly by the total number of tickets they have sold.
GO;	
create function matchesRankedByAttendance () returns table
AS 
return

	select C1.name "Host Name", C2.name "Guest Name", count(T.ticket_id) "number of tickets" from Match M
	inner join Club C1 on M.host_club_id = C1.club_id
	inner join Club C2 on M.guest_club_id = C2.club_id
	inner join Ticket T on M.match_id = T.match_id
	where T.status = 0 
	group by M.match_id,C1.name,C2.name
	order by count(T.ticket_id) offset 0 rows



--type: function
--name: requestsFromClub
--input: varchar(20) representing name of a stadium, varchar(20) representing name of a club
--output: table
--description: returns a table containing the name of the host club and the name of the guest club
--of all matches that are requested to be hosted on the given stadium sent by the representative of
--the given club.
GO;
create function requestsFromClub (@staduim_name varchar(20),@club_name varchar(20)) returns table
AS
return

	select H.name as 'Host Club', G.name as 'Guest Club' from ClubRepresentative CR
	inner join Club H on CR.club_id = H.club_id
	inner join HostRequest HR on HR.representative_id = CR.id
	inner join StadiumManager MG on HR.manager_id = MG.id
	inner join Match M on M.match_id = HR.match_id
	inner join Club G on M.guest_club_id = G.club_id
	inner join Stadium S on S.stadium_id = MG.stadium_id
	where S.name = @staduim_name and H.name = @club_name and HR.status is null and H.club_id < G.club_id




