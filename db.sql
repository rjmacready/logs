
CREATE TABLE codecovstore(id integer primary key, reqid nvarchar(10), ts timestamp, content text);

CREATE TABLE configmapstore(id integer primary key, configid integer, serverpath text, localpath text);
CREATE TABLE configstore(id integer primary key, description text);

CREATE TABLE errstore(id integer primary key, ts timestamp, type text, msg text, file text, line text, context text);

CREATE TABLE profilecallstore(id integer primary key, cmdid integer, function_name text, lnr integer, cost integer);
CREATE TABLE profilecmdstore(id integer primary key, profileid integer, cmd text);
CREATE TABLE profileinvstore(id integer primary key, cmdid integer, function_name text, lnr integer, cost integer, filename text);
CREATE TABLE profilestore(id integer primary key, filename text);

CREATE TABLE requeststore(id integer primary key, reqid nvarchar(10), ts timestamp, request_uri text, request_time timestamp, remote_addr nvarchar(20), remote_port integer);

CREATE TABLE tracelinestore(id integer primary key, traceid integer, level integer, function_no integer, kind integer, timeoffset float, memory integer, function_name text, deftype integer, filename text, included text, lineno integer, parent integer);
CREATE TABLE tracestore(id integer primary key, filename text);
