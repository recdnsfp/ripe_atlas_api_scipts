#!/usr/bin/env python

import json
import urllib2
import sys

probes = []

m_file = sys.argv[1]
output_dir = sys.argv[2]

print "Fetching results..."

measurements = json.loads(open(m_file).read())
for measurement_id in measurements:
        print measurement_id
        request = urllib2.Request("https://atlas.ripe.net/api/v2/measurements/%d/results?key=<KEY>" % (measurement_id))
        request.add_header("Accept", "application/json")
        conn = urllib2.urlopen(request)
        r = json.load(conn)
        open(output_dir+"/"+str(measurement_id)+".json",'w').write(json.dumps(r))

