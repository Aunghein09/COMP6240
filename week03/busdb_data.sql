
insert into stop values (14, 'City Interchange platform 4', 'City');
insert into stop values (19, 'Legislative Assembly London Cct', 'City');
insert into stop values (55, 'ANU Rimmer Street', 'Acton');
insert into stop values (72, 'Woden Interchange', 'Phillip');
insert into stop values (91, 'Tuggeranong Interchange', 'Greenway');

insert into route values
(4, 'Tuggeranong via City and Woden', 'Belconnen via Woden and City');
insert into route values (20, 'Bonner loop', null);

insert into visit values (4, 55, null);
insert into visit values (4, 14, 55);
insert into visit values (4, 19, 14);
insert into visit values (4, 72, 19);
insert into visit values (4, 91, 72);

insert into timetable values (4, true, 'Weekday', 55, '05:48');
insert into timetable values (4, true, 'Weekday', 55, '06:02');
insert into timetable values (4, true, 'Weekday', 72, '06:05');
insert into timetable values (4, true, 'Weekday', 72, '06:12');
insert into timetable values (4, true, 'Weekday', 91, '06:21');
insert into timetable values (4, true, 'Weekday', 91, '06:28');

insert into timetable values (4, false, 'Weekday', 91, '05:31');
insert into timetable values (4, false, 'Weekday', 91, '05:43');
insert into timetable values (4, false, 'Weekday', 55, '06:11');
insert into timetable values (4, false, 'Weekday', 55, '06:23');
