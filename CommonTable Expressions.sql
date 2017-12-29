
drop table FUMAR_SITES
go

create table FUMAR_SITES (
    SiteNumber int primary key nonclustered,
    SiteName nvarchar(100),
    XCoordinate int check (XCoordinate between -100 and 100),
    YCoordinate int check (YCoordinate between -100 and 100)
)
go

drop procedure GENERATE_FUMAR_SITES
go

create procedure GENERATE_FUMAR_SITES
as begin
    delete from FUMAR_SITES

    insert into FUMAR_SITES select 0, 'Original Position', 0, 0

    declare @siteNumber int
    set @siteNumber = 1

    while @siteNumber <= 4 begin
        insert into FUMAR_SITES 
        select @siteNumber, 'Site #' + convert(nvarchar, @siteNumber),
               100 - floor(rand()*200), 100 - floor(rand()*200)
        
        set @siteNumber = @siteNumber + 1
    end
end
go

exec GENERATE_FUMAR_SITES
go


drop view FUMAR_PATHS
go

create view FUMAR_PATHS (StartSite, EndSite, Distance) as
WITH CTE_A(StartSite,EndSite,Distance) AS(
	SELECT convert(nvarchar(30),A.SiteNumber) StartSite,convert(nvarchar(30),B.SiteNumber) EndSite,
	Convert(decimal(5,2),SQRT((SQUARE(A.XCoordinate - B.XCoordinate))+(SQUARE(A.YCoordinate - B.YCoordinate)))) DISTANCE
	From FUMAR_SITES A
	join FUMAR_SITES B on A.SiteNumber <= 4 
    and  B.SiteNumber <= 4 )
	Select * FROM CTE_A 
	EXCEPT 
	SELECT * FROM CTE_A Where StartSite = 0 and EndSite = 0
	go
	
	Select * from FUMAR_PATHS
	go
drop procedure GET_SHORTEST_FUMAR_PATH
go

create procedure GET_SHORTEST_FUMAR_PATH
as begin
declare @Site1coordinates varchar(100), @Site2coordinates varchar(100), @Site3coordinates varchar(100), @Site4coordinates varchar(100)
	set @Site1coordinates = (SELECT ('Site 1 ' + Concat('(' , XCoordinate , ',' , YCoordinate , ')')) Site1 from FUMAR_SITES where SiteNumber = 1)
	set @Site2coordinates = (SELECT ('Site 2 ' + Concat('(' , XCoordinate , ',' , YCoordinate , ')')) Site2 from FUMAR_SITES where SiteNumber = 2)
	set @Site3coordinates = (SELECT ('Site 3 ' + Concat('(' , XCoordinate , ',' , YCoordinate , ')')) Site3 from FUMAR_SITES where SiteNumber = 3)
	set @Site4coordinates = (SELECT ('Site 4 ' + Concat('(' , XCoordinate , ',' , YCoordinate , ')')) Site4 from FUMAR_SITES where SiteNumber = 4)
	declare @minDistance decimal(8,2); declare @path varchar(max);

	WITH SHORTEST_PATH AS
	(
	Select StartSite,EndSite,Convert(decimal(8,2),DISTANCE) DISTANCE,
	Convert(varchar(100),'Original Position(0,0)' +' -> ' + ' Site ' + EndSite ) PATH  
	FROM FUMAR_PATHS 
	where  StartSite = 0 and EndSite <= 4
	UNION ALL
	Select A.StartSite,A.EndSite,Convert(decimal(8,2),(A.DISTANCE + S.DISTANCE)) TOTAL_DISTANCE ,Convert(varchar(100), S.PATH +' -> ' + ' Site ' + A.EndSite) PATH
	FROM FUMAR_PATHS A, SHORTEST_PATH S
	Where  A.StartSite = S.EndSite
	and A.EndSite <> S.StartSite
	and S.PATH NOT LIKE ('%' + A.EndSite + '%') 
	)
	Select TOP 1 @minDistance = DISTANCE, @path = PATH from SHORTEST_PATH
	order by LEN(PATH) DESC, DISTANCE ASC
	set @path = (Select REPLACE 
					(REPLACE
					(REPLACE
					(REPLACE (@path,'Site 1',@Site1coordinates),
					'Site 2',@Site2coordinates),
					'Site 3',@Site3coordinates),
					'Site 4',@Site4coordinates))
	print 'Distance' + '              ' + 'ThePath'
	print '---------' + '          ' + '----------------------------------------------------------------------------------------------------------------'
	print convert(varchar,@minDistance) + '                ' + @path
	end	
go

exec GET_SHORTEST_FUMAR_PATH
go
