
-- drop tables if they exist
drop table if exists stop cascade;
drop table if exists route cascade;
drop table if exists visit cascade;
drop table if exists timetable cascade;

-- Information about bus stops.
-- Each stop is identified by its unique number, and has a
-- description and the suburb it is in.

create table stop (
  number      integer,
  description varchar,
  suburb      varchar
);

-- Information about bus routes.
-- Each stop is identified by its unique number.
-- A bus route has two descriptions (called "outbound" and "inbound"),
-- one for each direction of travel, except if it is a loop service,
-- in which case only the outbound description is used.

create table route (
  number      integer,
  outbound    varchar,
  inbound     varchar
);

-- Which stops are visited by a bus route.
-- Route is the route number and stop is the stop number; after_stop
-- is the number of the previous stop along the route, so that the
-- order of the stops can be determined. For the first stop on the
-- route, there is no previous stop.

create table visit (
  route       integer,
  stop        integer,
  after_stop  integer
);

-- Time table for a route.
-- All routes have departure times for the first stop, and some have
-- specified departure times for some other stops along the route.

create table timetable (
  route       integer,
  direction   boolean, -- True if outbound direction
  dow         varchar(10), -- one of "Weekday", "Saturday" or "Sunday"
  stop        integer,
  depart      time
);
