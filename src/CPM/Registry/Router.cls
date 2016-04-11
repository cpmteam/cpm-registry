Class CPM.Registry.Router Extends %CSP.REST
{

XData UrlMap
{
<Routes>
<Route Url="/" Method="GET" Call="DatabaseInfo" Cors="true"/>
<Route Url="/-/ping" Method="GET" Call="Ping" Cors="true"/>
<Route Url="/-/ping/.*" Method="GET" Call="Ping" Cors="true"/>
</Routes>
}

ClassMethod outputJSON(json) As %Status
{
	Set %response.ContentType = ..#CONTENTTYPEJSON
	
	set stream = ##class(%Stream.TmpCharacter).%New()
	do json.$toJSON(stream)
	do stream.OutputToDevice()
	
	quit $$$OK
}

ClassMethod DatabaseInfo() As %Status
{	
	set startTime = ..StartTime()
	set info = {
		"db_name": "registry",
		"doc_count": 0,
		"doc_del_count": 0,
		"update_seq": 0,
		"purge_seq": 0,
		"compact_running": false,
		"disk_size": 0,
		"data_size": 0,
		"instance_start_time": startTime,
		"disk_format_version": 6,
		"committed_update_seq": 0
	}
	
	quit ..outputJSON(info)
}

/// Timestamp of when the server was launched, expressed in microseconds since the epoch
ClassMethod StartTime() As %Integer
{
	set startTime = $zts
	set startTime = ($piece(startTime,",")-47117)*86400 + $piece(startTime,",",2)
	set startTime = startTime - $zh
	quit $j(startTime * 1000, 0, 0)
}


ClassMethod Ping() As %Status 
{
	set peer = %request.GetCgiEnv("REMOTE_ADDR")
	set pong = {
		"host": %request.GetCgiEnv("HTTP_HOST"),
		"ok": true,
		"username": null,
		"peer": peer
	}
	
	quit ..outputJSON(pong)
}
}
