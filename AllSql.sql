





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



--=========================================================================================================
insert into SystemUser values('admin','admin')
insert into SystemAdmin (name,username) values('Admin','admin')



--select * from SystemUser
--select * from Club
--select * from ClubRepresentative
--select * from Stadium
--select * from StadiumManager
--select * from Fan


go
create proc addClub
	@club_name varchar(20),
	@location  varchar(20),
	@result int output
as
begin
	if not exists (select * from Club where name= @club_name)
	begin
		insert into Club(name,location) values(@club_name,@location)
		set @result = 1
	end
	else
		set @result = 0
end




go
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




go
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



go
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




go
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


go
create proc unblockFan
	@national_id varchar(20),
	@result int output
	--@name varchar(20) output
as
begin
	--declare @fanName varchar(20)
	--select @fanName = name from Fan where national_id = @national_id

	if exists (select * from Fan where national_id = @national_id)
	begin
		update Fan set status = 1 where national_id = @national_id
		--set @name = @fanName 
		set @result = 1
	end
	else
	begin
		--set @name = ''
		set @result = 0
	end
end

--=========================================================================================================


--select * from SportsAssociationManager
--insert into SystemUser values('messi','messi') 
--insert into SportsAssociationManager(name,username) values('Lionel Messi','messi') 



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



go
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




go
create proc addNewMatch
	@host_name varchar(20),
	@guest_name varchar(20),
	@start_time datetime,
	@end_time datetime,
	@result int output
as
begin
	declare @guest_id int
	declare @host_id int
	select @host_id = club_id from Club where name = @host_name
	select @guest_id = club_id from Club where name = @guest_name

	if (@host_id is not null and @guest_id is not null) and not exists(select * from Match where host_club_id = @host_id and guest_club_id = @guest_id and start_time = @start_time)
	begin
		insert into Match(start_time,end_time,stadium_id,host_club_id,guest_club_id)
		values(@start_time,@end_time,null,@host_id,@guest_id);
		set @result = 1
	end
	else
		set @result = 0
end



go
create view getAllMatches
as
	select H.name as 'hostName', G.name as 'guestName',M.start_time as 'starts',M.end_time as 'ends', S.name as 'stadName', S.location as 'location' from Match M 
	inner join Club H on M.host_club_id = H.club_id
	inner join Club G on M.guest_club_id = G.club_id
	left outer join Stadium S on M.stadium_id = S.stadium_id


go


--select * from getAllMatches 




go
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
	


go
create view allComingMatches
as
	select H.name as 'hostName', G.name as 'guestName',M.start_time as 'starts',M.end_time as 'ends',S.name as 'stadName', S.location as 'location' from Match M
	inner join Club H on M.host_club_id = H.club_id
	inner join Club G on M.guest_club_id = G.club_id
	left outer join Stadium S on M.stadium_id = S.stadium_id
	where M.start_time > CURRENT_TIMESTAMP 


go
create view allPlayedMatches
as
	select H.name as 'hostName', G.name as 'guestName',M.start_time as 'starts',M.end_time as 'ends',S.name as 'stadName', S.location as 'location' from Match M
	inner join Club H on M.host_club_id = H.club_id
	inner join Club G on M.guest_club_id = G.club_id
	left outer join Stadium S on M.stadium_id = S.stadium_id
	where M.start_time < CURRENT_TIMESTAMP 



go
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

--===============================================================================================================

go
create proc clubRepLogin
	@username varchar(20),
	@password varchar(20),
	@result int output
as
begin
	
	if exists( select * from ClubRepresentative where username = @username)
	begin
		if exists (select * from SystemUser where username = @username and password = @password)
			set @result = 1
		else
			set @result = 0
	end
end




--2.3.a
go
create proc addRepresentative
	@rep_name varchar(20),
	@club_name varchar(20),
	@username varchar(20),
	@password varchar(20),
	@result int output
as
begin
	declare @club_id int
	select @club_id = club_id from Club where name = @club_name

	if not exists (select * from SystemUser where username = @username) -- check if there is an already token username
	begin
		if not exists (select * from ClubRepresentative where club_id = @club_id) -- check if there is an already token club name
		begin
			insert into SystemUser(username,password) values (@username,@password)
			insert into ClubRepresentative(name,club_id,username) values (@rep_name,@club_id,@username)
			set @result = 1
		end
		else
			set @result = 0
	end
	else
		set @result = 0
end
insert into Club (name,location) values ('Al Ahly','cairo, Egypt')


--2.3.b
go
create proc getClubName
	@repUsername varchar(20),
	@clubName varchar(20) output
as
begin
	declare @name varchar(20)
	select @name = C.name from Club C
	inner join ClubRepresentative R on C.club_id = R.club_id
	where R.username = @repUsername

	set @clubName = @name
end


go
create proc getStadiumName
	@stadiumId int,
	@stadiumName varchar(20) output
as
begin
	declare @name varchar(20)
	select @name = name from Stadium where stadium_id = @stadiumId
	set @stadiumName = @name
end

--drop proc getStadiumName


--insert into SystemUser(username,password) values('gattuso','gattuso')


--set identity_insert Stadium on
--insert into Stadium (stadium_id,name,location,status,capacity) values (13,'San Siro','Milano, Italia',1,80018);
--set identity_insert Stadium off
--select * from Stadium

--set identity_insert StadiumManager on
--insert into StadiumManager(id,name,username,stadium_id) values(13,'Gattuso','gattuso',13)
--set identity_insert StadiumManager off



--2.3.c
go
--type: function
--name: upcomingMatchesOfClub
--input: varchar(20) representing a club name
--output: table
--description: returns a table containing the info of upcoming matches which the given club will
--play. All already played matches should not be included. The info should be the given club name,
--the competing club name , the starting time of the match and the name of the stadium hosting the
--match.

create function upcomingMatchesOfClub (@club_name varchar(20)) returns table
as
return 
	(select C.name as'firstClub', C2.name as 'secondClub', M.start_time as 'starts',M.end_time as 'ends', S.name as'stadName' from Club C
	inner join Match M on C.club_id = M.host_club_id
	inner join Club C2 on C2.club_id = M.guest_club_id
	left outer join Stadium S on S.stadium_id = M.stadium_id
	where M.start_time > current_timestamp and C.name = @club_name)
	UNION 
	(select C.name as'firstClub', C2.name as 'secondClub', M2.start_time as 'starts',M2.end_time as 'ends', S.name as 'stadName' from Club C
	inner join Match M2 on C.club_id = M2.guest_club_id
	inner join Club C2 on C2.club_id = M2.host_club_id
	left outer join Stadium S on S.stadium_id = M2.stadium_id
	where M2.start_time > current_timestamp and C.name = @club_name)


go
--drop function upcomingMatchesOfClub
--select * from Match
----Real Madrid - Barcelona (upcoming)
--insert into Match (host_club_id,guest_club_id,start_time,end_time,stadium_id) values (1,2,'12/26/2022','12/26/2022',13)

----Real Madrid - Athletic Bilbao (upcoming)
--insert into Match (host_club_id,guest_club_id,start_time,end_time,stadium_id) values (1,3,'12/26/2022','12/26/2022',1)

----Real Madrid - Sevilla (upcoming)
--insert into Match (host_club_id,guest_club_id,start_time,end_time) values (1,5,'12/26/2022','12/26/2022')

----Real Madrid - Paris Saint German (upcoming)
--insert into Match (host_club_id,guest_club_id,start_time,end_time) values (1,8,'12/26/2022','12/26/2022')

----Real Madrid - Bayern Munchen (Already Played)
--insert into Match (host_club_id,guest_club_id,start_time,end_time) values (1,6,'12/24/2022','12/24/2022')


--select * from dbo.upcomingMatchesOfClub('Real Madrid')





--2.3.d
go
--type: function
--name: viewAvailableStadiumsOn
--input: datetime
--output: table
--description: returns a table containing the name, location and capacity of all stadiums which are
--available for reservation and not already hosting a match on the given date.
create function viewAvailableStadiumsOn ( @date datetime) returns table
as
return
	select S.name as 'stadiumName',S.location as 'location',S.capacity as 'capacity' from Stadium S where status = 1 and not exists (
		select * from Stadium S1 inner join Match M on S1.stadium_id = M.stadium_id and M.start_time >= @date and S1.stadium_id = S.stadium_id
	);  

go

--set identity_insert Stadium on;
--insert into Stadium (stadium_id,name,location,status,capacity) values (1,'Santiago Bernabio','Madrid, España',1,81044);
--insert into Stadium (stadium_id,name,location,status,capacity) values (2,'Camp Nou','Catalonia, España',1,99354);
--insert into Stadium (stadium_id,name,location,status,capacity) values (3,'San Mames','Basque, España',1,53289);
--insert into Stadium (stadium_id,name,location,status,capacity) values (4,'Metropolitano','Madrid, España',1,68456);
--insert into Stadium (stadium_id,name,location,status,capacity) values (5,'Ramon Sanchez-Pizjuan','Andalusia, España',1,42714);
--insert into Stadium (stadium_id,name,location,status,capacity) values (6,'Allianz Arena','Bavaria, Deutschland',1,75024);
--set identity_insert Stadium off;

--select * from Stadium
--insert into Match(host_club_id,guest_club_id,start_time,stadium_id) values (6,5,'11/28/2022',6)
--select * from dbo.viewAvailableStadiumsOn('11/28/2022')



go
create proc addHostRequest
	@club_name varchar(20),
	@stadium_name varchar(20),
	@start_time datetime,
	@result int output
as
begin
	declare @club_id int
	declare @stadium_id int
	declare @match_id int
	declare @manager_id int
	declare @rep_id int

	select @club_id = club_id from Club where name = @club_name
	select @stadium_id = stadium_id from Stadium where name = @stadium_name
	select @match_id = match_id from Match where start_time = @start_time and @club_id = host_club_id
	select @rep_id = id from ClubRepresentative where club_id = @club_id
	select @manager_id = id from StadiumManager where stadium_id = @stadium_id

		
	if(@club_id is not null and @manager_id is not null)
	begin
	--Note: the status of the host request is initially null
		insert into HostRequest (match_id,representative_id,manager_id,status) values (@match_id,@rep_id,@manager_id,null)
		set @result = 1
	end
	else
		set @result = 0
end


--select * from Club
--select * from Stadium
--select * from StadiumManager
--select * from Match

--insert into Match (host_club_id,guest_club_id,start_time) values(5,7,'12/29/2022')
--exec addHostRequest 'Sevilla','San Siro','12/29/2022'
--select * from HostRequest



go
create view getAllClubReps
as
	select CR.name as 'repName', C.name as 'clubName', C.location as 'location' from Club C
	inner join ClubRepresentative CR on C.club_id = CR.club_id



go
create view getAllStadiumManagers
as
	select SM.name as 'manName', S.name as 'stadName', S.location as 'location' from Stadium S
	inner join StadiumManager SM on S.stadium_id = SM.stadium_id



go
create view getSystemRequests
as
	select CR.name as 'senderName',H.name as 'hostName',G.name as 'guestName',M.start_time as 'starts', M.end_time as 'ends', HR.status as 'status' from HostRequest HR
	inner join ClubRepresentative CR on HR.representative_id = CR.id
	inner join StadiumManager SM on HR.manager_id = SM.id
	inner join Match M on M.match_id = HR.match_id
	inner join Club H on M.host_club_id = H.club_id
	inner join Club G on M.guest_club_id = G.club_id


go
--select * from getSystemRequests
--select * from HostRequest


--================================================================================================================

create proc stadManLogin
	@username varchar(20),
	@password varchar(20),
	@result int output
as
begin
	
	if exists( select * from StadiumManager where username = @username)
	begin
		if exists (select * from SystemUser where username = @username and password = @password)
			set @result = 1
		else
			set @result = 0
	end
end



go
create proc getStadName
	@manUsername varchar(20),
	@stadName varchar(20) output
as
begin
	declare @name varchar(20)
	select @name = S.name from Stadium S
	inner join StadiumManager M on S.stadium_id = M.stadium_id
	where M.username = @manUsername

	set @stadName = @name
end



go
create proc addStadiumManager
	@manager_name varchar(20),
	@stadium_name varchar(20),
	@username varchar(20),
	@password varchar(20),
	@result int output
as
begin
	declare @stadium_id int
	select @stadium_id = stadium_id from Stadium where name = @stadium_name

	if(@stadium_id is null)
		set @result = 0
	else
	begin
		if not exists (select * from StadiumManager MG where MG.stadium_id = @stadium_id)
		begin
			insert into SystemUser(username,password) values (@username,@password)
			insert into StadiumManager(name,stadium_id,username) values (@manager_name,@stadium_id,@username)
			set @result = 1
		end
		else
			set @result = 0
	end
end


go
--create proc addHostRequest
--	@club_name varchar(20),
--	@stadium_name varchar(20),
--	@start_time datetime
--as
--begin
--	declare @club_id int
--	declare @stadium_id int
--	declare @match_id int
--	declare @manager_id int
--	declare @rep_id int

--	select @club_id = club_id from Club where name = @club_name
--	select @stadium_id = stadium_id from Stadium where name = @stadium_name
--	select @match_id = match_id from Match where stadium_id = @stadium_id and start_time = @start_time and host_club_id = @club_id
--	select @rep_id = id from ClubRepresentative where club_id = @club_id
--	select @manager_id = id from StadiumManager where stadium_id = @stadium_id

		
--	if(@club_id is not null and @manager_id is not null)
--	--Note: the status of the host request is initially null
--	insert into HostRequest (match_id,representative_id,manager_id,status) values (@match_id,@rep_id,@manager_id,null)

--end


go
create function getAllRequests(@username varchar(20)) returns table
as
return
	select CR.name as 'senderName',H.name as 'hostName',G.name as 'guestName',M.start_time as 'starts', M.end_time as 'ends', HR.status as 'status' from HostRequest HR
	inner join ClubRepresentative CR on HR.representative_id = CR.id
	inner join StadiumManager SM on HR.manager_id = SM.id
	inner join Match M on M.match_id = HR.match_id
	inner join Club H on M.host_club_id = H.club_id
	inner join Club G on M.guest_club_id = G.club_id
	where SM.username = @username
go


--insert into SystemUser(username,password) values('gattuso','gattuso')

--set identity_insert Club on
--insert into Club(club_id,name,location) values (5,'Sevilla',	'Andalusia, España')
--insert into Club(club_id,name,location) values (7,'Borussia Dortmund', 'Dortmund,Deutschland')
--set identity_insert Club off

--set identity_insert Stadium on
--insert into Stadium (stadium_id,name,location,status,capacity) values (13,'San Siro','Milano, Italia',1,80018);
--set identity_insert Stadium off

--set identity_insert StadiumManager on
--insert into StadiumManager(id,name,username,stadium_id) values(13,'Gattuso','gattuso',13)
--set identity_insert StadiumManager off

--insert into Match (host_club_id,guest_club_id,start_time) values(5,7,'12/29/2022')


--insert into SystemUser values('jesusnavas','jesusnavas')
--set identity_insert ClubRepresentative on
--insert into ClubRepresentative(id,club_id,name,username) values (5,5,'Jesus Navas',	'jesusnavas')
--set identity_insert ClubRepresentative off

--select * from Match
--insert into HostRequest (manager_id,representative_id,match_id,status) values(13,5,43,null)

--select * from Club
--select * from Stadium
--select * from HostRequest
--select * from ClubRepresentative
--select * from StadiumManager
--select * from dbo.getAllRequests('gattuso')
--insert into Stadium (name,location,capacity) values('Borg el arab','Alex, Egypt',50000);



go
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

--===============================================================================================================




go
create proc fanLogIn
	@username varchar(20),
	@password varchar(20),
	@fan_id varchar(20),
	@result int output
as
begin
	
	if exists( select * from Fan where username = @username)
	begin
		if exists (select * from SystemUser where username = @username and password = @password)
			if exists(select * from Fan where username = @username and status = 1 and national_id = @fan_id)
				set @result = 1
			else
				set @result = 0
		else
			set @result = 0
	end
end



go
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
		insert into SystemUser(username,password) values(@username,@password)
		insert into Fan (name,national_id,birth_date,address,phone_number,status,username) values(@name,@national_id_number,@birth_date, 
		@address, @phone_number,1,@username)
		set @result = 1
	--make status 1 initially
	end
	else
		set @result = 0
end


go
create function viewAllMatches(@date datetime) returns table
as
return
	select H.name as 'hostName', G.name as 'guestName',M.start_time as 'starts', S.name as 'stadName', S.location as 'location' from Match M 
	inner join Club H on M.host_club_id = H.club_id
	inner join Club G on M.guest_club_id = G.club_id
	inner join Stadium S on M.stadium_id = S.stadium_id
	where exists (select * from Ticket T inner join Match M2 on M2.match_id = T.match_id and T.status = 1 and M.match_id = M2.match_id)
	and M.start_time = @date


go
--set identity_insert Club on
--insert into Club(club_id,name,location) values (1,'Real Madrid', 'Madrid, España')
--insert into Club(club_id,name,location) values(2,'Barcelona', 'Catalonia, España')
--insert into Club(club_id,name,location) values (3,'Athletic bilbao', 'Basque, España')
--insert into Club(club_id,name,location) values (4,'Athletico Madrid', 'Madrid, España')
--insert into Club(club_id,name,location) values (5,'Sevilla',	'Andalusia, España')
--insert into Club(club_id,name,location) values (6,'Bayern Munchen', 'Bavaria, Deutschland')
--set identity_insert Club off

--set identity_insert Stadium on
--insert into Stadium (stadium_id,name,location,status,capacity) values (13,'San Siro','Milano, Italia',1,80018);
--set identity_insert Stadium off

--select * from Match
--select * from Stadium
--insert into Match(host_club_id,guest_club_id,start_time,stadium_id) values(1,2,'12/28/2022',13)--has T
--insert into Match(host_club_id,guest_club_id,start_time,stadium_id) values(3,4,'12/28/2022',13)--has T
--insert into Match(host_club_id,guest_club_id,start_time,stadium_id) values(5,6,'12/28/2022',13)--has T

--insert into Match(host_club_id,guest_club_id,start_time,stadium_id) values(1,5,'12/28/2022',13)--no T
--insert into Match(host_club_id,guest_club_id,start_time,stadium_id) values(1,6,'12/28/2022',13)--no T

--insert into Ticket (match_id,status) values (44,1)
--insert into Ticket (match_id,status) values (44,1)

--insert into Ticket (match_id,status) values (45,1)
--insert into Ticket (match_id,status) values (45,0)


--insert into Ticket (match_id,status) values (46,1)
--insert into Ticket (match_id,status) values (46,1)


--insert into Ticket (match_id,status) values (47,0)
--insert into Ticket (match_id,status) values (47,0)


--select * from dbo.viewAllMatches('10/01/2023')



go
CREATE VIEW allTickets
AS
	SELECT C1.name as 'hostName',C2.name as 'guestName' , S1.name as 'stadName' ,M.start_time as 'start' 
	FROM Ticket T
	inner join Match  M on M.match_id=T.match_id 
	inner join Club C1 on M.host_club_id=C1.club_id 
	inner join Club C2 on M.guest_club_id=C2.club_id
	inner join Stadium S1 on S1.stadium_id=M.stadium_id
	where T.status = 1 

go


--select * from allTickets




go
create proc purchaseTicket
	@national_id varchar(20),
	@host_club_name varchar(20),
	@guest_club_name varchar(20),
	@start_time datetime,
	@result int output
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
			set @result = 1
		end
		else
			set @result = 0 --no available ticket
	end
	else
		set @result = 0 --Fan is blocked, thus cannot purchase a ticket
end

--select * from Fan



go
create function getAllTickets(@id varchar(20)) returns table
as
return
	select F.name as 'fanName',H.name as 'hostName', G.name as 'guestName',M.start_time as 'starts',S.name as 'stadName' from Ticket T
	inner join Fan F on T.fan_id = F.national_id
	inner join Match M on T.match_id = M.match_id
	inner join Club H on M.host_club_id = H.club_id
	inner join Club G on M.guest_club_id = G.club_id
	inner join Stadium S on M.stadium_id = S.stadium_id
	where F.national_id = @id




--===============================================================================================================