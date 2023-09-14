drop table #AllLoginAttempts
       create table #AllLoginAttempts (cid int, LoginAttemptDateTime datetime,IsFailLogin bit)
       
       
       insert into #AllLoginAttempts (CID, LoginAttemptDateTime, IsFailLogin)
       values (1, '2018-01-01', 0),
              (1, '2018-01-02', 1),
              (2, '2018-01-01', 0),
              (1, '2018-01-03', 1),
              (2, '2018-01-02', 0),
              (1, '2018-01-04', 0),
              (1, '2018-01-05', 1),
              (1, '2018-01-06', 1),
              (1, '2018-01-07', 1),
              (1, '2018-01-08', 0),
              (1, '2018-01-09', 1),
              (1, '2018-01-10', 1),

              (1, '2018-01-11', 0),
              (1, '2018-01-12', 0),
              (1, '2018-01-12 01:00:00', 0),
              (1, '2018-01-12 02:00:00', 0),

              (1, '2018-01-13', 1),
              (1, '2018-01-14', 1),
              
              (1, '2018-01-15', 1),
              (1, '2018-01-16', 1),
              (1, '2018-01-17', 0),
              (1, '2018-01-18', 0),
              (1, '2018-01-19', 1),

              (2, '2018-01-03', 1),
              (2, '2018-01-04', 0),
              (2, '2018-01-05', 0),
              (2, '2018-01-06', 1),
              (2, '2018-01-07', 1),
              (2, '2018-01-08', 0),
              (2, '2018-01-09', 1),
              (2, '2018-01-10', 1),
              (2, '2018-01-11', 1),
              (3, '2018-01-03', 1),
              (3, '2018-01-04', 0),
              (3, '2018-01-05', 0),
              (3, '2018-01-06', 1),
              (3, '2018-01-07', 1),
              (3, '2018-01-08', 0),
              (3, '2018-01-09', 1),
              (3, '2018-01-10', 1),
              (3, '2018-01-11', 1),
              (3, '2018-01-12', 1),
			  (3, '2018-01-13', 1)

alter table #allLoginAttempts add NrCrt int identity(1,1)


select * from #AllLoginAttempts
order by CId, LoginAttemptDateTime

select t.*
from (select t.*, count(*) over (partition by grp, CID, IsFailLogin) as cnt
      from (select t.*,
                   (row_number() over (partition by CID order by LoginAttemptDateTime) -
                    row_number() over (partition by CID, IsFailLogin order by LoginAttemptDateTime)
                   ) as grp
            from #AllLoginAttempts t
           ) t
      where IsFailLogin = 1
     ) t
where cnt >= 3;