--Joins Vs Map-Side Join

--events_raw;

session_id              string
vr_sequence_number      int
gmt_date_time2          timestamp
timezone_code           string
application_code        string
sub_application_code    string
event_category          string
event_code              string
result_code             string
call_variable_value     string
request_name            string
vps_number              string
line_number             string
country_id              string
vr_platform_type_cd     string
call_gmt_date_time      string
completed_indicator     string
source_name             string
lst_updt_id             string
lst_updt_dt             timestamp

--events_fact;

unique_call_id          string
session_id              string
session_id_seq_no       int
geotel_id               string
local_date_time_stamp   string
vr_sequence_number      int
vr_sequence_number_max  int
year                    int
month                   int
day                     int


-- Left Join 

select a.session_id,b.session_id,b.local_date_time_stamp
from events_raw a
left join events_fact b
on a.session_id = b.session_id;

Hadoop job information for Stage-3: number of mappers: 1; number of reducers: 0

Time taken: 18.152 seconds, Fetched: 698032 row(s)

Time taken: 14.752 seconds, Fetched: 698032 row(s)

Time taken: 15.603 seconds, Fetched: 698032 row(s)



-- Auto Join Convert
set hive.auto.convert.join=true;
select a.session_id,b.session_id,b.local_date_time_stamp
from events_raw a
left join events_fact b
on a.session_id = b.session_id;


set hive.auto.convert.join=false;
select a.session_id,b.session_id,b.local_date_time_stamp
from events_raw a
left join events_fact b
on a.session_id = b.session_id;

Total jobs = 1
Number of reduce tasks not specified. Estimated from input data size: 1
Hadoop job information for Stage-1: number of mappers: 3; number of reducers: 1
2016-04-21 13:41:46,288 Stage-1 map = 0%,  reduce = 0%
2016-04-21 13:41:52,631 Stage-1 map = 67%,  reduce = 0%, Cumulative CPU 2.49 sec
2016-04-21 13:41:56,803 Stage-1 map = 100%,  reduce = 0%, Cumulative CPU 8.39 sec
Time taken: 26.961 seconds, Fetched: 698032 row(s)



set hive.auto.convert.join=true;


select /*+ MAPJOIN(events_raw) */ a.session_id,b.session_id,b.local_date_time_stamp 
from events_raw a
left join events_fact b
on a.session_id = b.session_id;


Total jobs = 1
Hadoop job information for Stage-3: number of mappers: 1; number of reducers: 0
2016-04-21 13:43:24,701 Stage-3 map = 0%,  reduce = 0%
Time taken: 22.791 seconds, Fetched: 698032 row(s)


