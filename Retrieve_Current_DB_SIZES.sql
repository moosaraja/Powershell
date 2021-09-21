/************************************************************
 * Code formatted by 
 *			SoftTree SQL Assistant © v7.0.158
 * Time: 	16.09.2015 13:04:07
 *
 * Code content is copyright of 
 * 			John Ness, ITP52, Bühler AG, Uzwil
 * 			©John Ness, 2015 - 2018
 * Modified by moosa to correct the null issue on Oct 2019
 * unless stated otherwised
 *
 ************************************************************/
 
--
-- uncomment the commented out lines to have individual file sizes for databases with mdf and ndf files
--

IF EXISTS (
       SELECT 1
       FROM   tempdb.sys.sysobjects AS t
       WHERE  NAME LIKE '#TempDatabaseSizes%'
   )
BEGIN
    DROP TABLE #TempDatabaseSizes
END
--DROP TABLE #TempDatabaseSizes
GO
CREATE TABLE #TempDatabaseSizes
(
	-- uncomment next line for more information
	DBS_FILE_NAME            VARCHAR(100),
	DBS_NAME                 VARCHAR(100),
	DBS_TYPE                 VARCHAR(20),
	DBS_Total_MB             INT,
	DBS_Total_MB_Max         INT,
	DBS_Total_Used_MB        INT,
	DBS_Sum_Available_MB     INT,
	DBS_Percent_Used         FLOAT
)

DELETE 
FROM   #TempDatabaseSizes
GO

sp_MSforeachdb 'USE [?];
Insert into #TempDatabaseSizes (
-- uncomment next line for more information
DBS_FILE_NAME,
	DBS_NAME, DBS_TYPE, DBS_Total_MB, DBS_Total_MB_Max, DBS_Total_Used_MB, DBS_Sum_Available_MB, DBS_Percent_Used)
SELECT  
-- uncomment next line for more information
        name as DB_File_Name,
        ''?'' as ''DB Name'',
        case TYPE
        WHEN 0 THEN ''DB Files''
        ELSE ''TLog Files''
        END AS ''File Types'',
        sum(CAST(size as BIGINT) * 8 / 1024) AS ''DB Total in MB'' ,
        sum(CAST(max_size as BIGINT) * 8 / 1024) as ''DB MaxSize in MB'' ,
        sum(CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT) * 8 / 1024) AS ''DB Total Space Used'',
        sum(CAST(size as BIGINT) * 8 / 1024 - CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT) * 8 / 1024) AS ''Sum Available Space MB'', 
        cast(sum(CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT) * 8 / 1024) as float) / cast(sum(size / 128) as float) * 100 as ''Percent Used''

FROM    sys.database_files
where MAX_size != -1
       AND max_size != 268435456
group BY type
-- uncomment next line for more information 
,name
union
SELECT  
-- uncomment next line for more information
        name as DB_File_Name,
        ''?'' as ''DB Name'',
        case TYPE
        WHEN 0 THEN ''DB Files''
        ELSE ''TLog Files''
        END AS ''File Types'',
        sum(CAST(size as BIGINT) * 8 / 1024) AS ''DB Total in MB'' ,
        0 as ''DB MaxSize in MB'' ,
        sum(CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT) * 8 / 1024) AS ''DB Total Space Used'',
        sum(CAST(size as BIGINT) * 8 / 1024 - CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT) * 8 / 1024) AS ''Sum Available Space MB'', 
        cast(sum(CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT) * 8 / 1024) as float) / cast(sum(size / 128) as float) * 100 as ''Percent Used''

FROM    sys.database_files
where MAX_size = -1
       or max_size = 268435456       
group BY type
-- uncomment next line for more information 
,name
'
GO
SELECT DBS_NAME,
       -- uncomment next line for more information
       DBS_FILE_NAME,
       DBS_TYPE,
       DBS_Total_MB,
       DBS_Total_MB_Max,
       DBS_Total_Used_MB,
       DBS_Sum_Available_MB,
       DBS_Percent_Used
FROM   #TempDatabaseSizes
--where DBS_NAME = 'Cherwell_ITSM'
/*
WHERE  DBS_NAME NOT IN (
--	'master', 
--	'model', 
--	'msdb', 
--	'pubs', 
--	'Northwind',
	'tempdb')
 */	
--AND DBS_Name LIKE 'Hyp%'
--group by ROLLUP (DBS_Total_Used_MB), ROLLUP (DBS_Total_MB_Max)
UNION 
SELECT ' [  SUM *.MDF, *.NDF',
       -- uncomment next line for more information
       '-',
       '-',
       sum(DBS_Total_MB),
       sum(DBS_Total_MB_Max),
       sum(DBS_Total_Used_MB),
       sum(DBS_Sum_Available_MB),
       0
FROM   #TempDatabaseSizes
WHERE  DBS_TYPE = 'DB Files'
UNION
SELECT ' [ SUM *.LDF',
       -- uncomment next line for more information
       '-',
       '-',
       sum(DBS_Total_MB),
       sum(DBS_Total_MB_Max),
       sum(DBS_Total_Used_MB),
       sum(DBS_Sum_Available_MB),
       0
FROM   #TempDatabaseSizes
WHERE  DBS_TYPE = 'TLog Files'
UNION
SELECT ' [======================',
       -- uncomment next line for more information
       '======================',
       '======================',
       0,
       0,
       0,
       0,
       0
FROM   #TempDatabaseSizes
ORDER BY
       1,
       3 
       --compute SUM(DBS_Total_Used_MB), SUM(DBS_Total_MB_Max)
       --AS SUM_DBS_Total_Used_MB
       --!!DIR \\UZN893\d$ /s
       -----------------------------------------------------------------
       -- in progress don't use
       -----------------------------------------------------------------
       /*
       SELECT DB_NAME(database_id),
       CASE max_size
       WHEN -1 THEN 0
       WHEN 268435456 THEN 0
       ELSE max_size * 8.0 / 1024 / 1024
       END AS SUM_MAX_SIZE_GB,
       max_size
       FROM   sys.master_files
       WHERE  TYPE != 1
       COMPUTE SUM(max_size)
       */
       -----------------------------------------------------------------
       -- Sum computable requirements for disk drive *.mdf
       -----------------------------------------------------------------
       /*
       SELECT SUM(max_size * 8 / 1024 / 1024) + 25 AS [SUM_MAX_GB (+SQL Inst.)],
       SUM(SIZE * 8.0 / 1024 / 1024) AS SUM_CURRENT_GB
       FROM   sys.master_files
       WHERE  TYPE != 1 -- any
       AND MAX_size != -1
       AND max_size != 268435456
       
       -- !!DIR \\UZN893\d$ /s       
       */
       -----------------------------------------------------------------
       -- Sum computable requirements for disk drive *.ldf
       -----------------------------------------------------------------
       /*
       SELECT SUM(max_size * 8.0 / 1024 / 1024) AS [SUM_MAX_GB],
       SUM(SIZE * 8.0 / 1024 / 1024) AS SUM_CURRENT_GB
       FROM   sys.master_files
       WHERE  TYPE = 1 -- Transaction Log Files
       AND MAX_size != -1
       AND max_size != 268435456
       
       -- !!DIR \\UZN556\d$ /s       
       */ 
       -----------------------------------------------------------------
       -- Computable requirements for all disk drives *.mdf & *.ldf
       -----------------------------------------------------------------
       /*
       SELECT NAME,
       max_size * 8.0 / 1024 / 1024  AS [MAX_GB],
       SIZE * 8.0 / 1024 / 1024 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT) * 8 / 1024 / 1024     AS [CURRENT_GB]
       FROM   sys.master_files
       WHERE  ---TYPE != 1 -- Anything but Transaction Log Files
       MAX_size != -1
       AND max_size != 268435456
       */
       
       -----------------------------------------------------------------
       -- Other statements
       -----------------------------------------------------------------
       /*      
       SELECT *
       FROM   sys.master_files mf
       WHERE  DB_NAME(mf.database_id) = 'tempdb'
       
       SELECT * FROM sys.database_files 
       
       SELECT 14417920 + 1310720

	   sp_helpdb SP01_Content_WA1_05
	   xp_fixeddrives

       ALTER DATABASE IbsBtsManagement MODIFY FILE(NAME = IbsBtsManagement, SIZE=32GB,MAXSIZE = 32GB)        
	   ALTER DATABASE tempdb MODIFY FILE(NAME = temp3, SIZE=1GB)        
	   ALTER DATABASE tempdb MODIFY FILE(NAME = temp4, SIZE=1GB)        
	   ALTER DATABASE tempdb MODIFY FILE(NAME = temp5, SIZE=1GB)        
	   ALTER DATABASE tempdb MODIFY FILE(NAME = temp6, SIZE=1GB)        
	   ALTER DATABASE tempdb MODIFY FILE(NAME = temp7, SIZE=1GB)        
	   ALTER DATABASE tempdb MODIFY FILE(NAME = temp2, SIZE=1GB)        
	   ALTER DATABASE tempdb MODIFY FILE(NAME = temp8, SIZE=1GB)        
       ALTER DATABASE msdb MODIFY FILE(NAME = MSDBLog, SIZE=2GB,MAXSIZE = 2GB)        

	   	   sp_helpdb tempdb

	   xp_fixeddrives
	   D:\MSSQL\OLTP\DATA\D3Q\data\d3_usr_01.ndf
       */






	   
	   

	   --select (440239 + 37217+ 231239+13933)/1024

	   --select (756800 + 71680+ 307200+16384)/1024