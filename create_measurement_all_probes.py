#!/usr/bin/env python

import pycurl
import json
import cStringIO
import sys
import time

def get_next(probes, offset, limit):
	result = []
	i = offset
	for probe in probes[offset:]:
		if(probe['status']==1):
			result.append(probe['id'])
		i = i+1
		if(len(result)==limit):
			break
	return (i, result)


tpl_file = sys.argv[1]
probes_file = sys.argv[2]
m_file = sys.argv[3]

offset = 0
limit = 1000


atlas_url='https://atlas.ripe.net/api/v2/measurements/?key=<KEY>'

data = json.loads(open(tpl_file).read())

probes_all = json.loads(open(probes_file).read())
probes = probes_all['objects']

m = []


class Buff:
   def __init__(self):
       self.contents = ''

   def body_callback(self, buf):
       self.contents = self.contents + buf

while True:

	(offset, p) = get_next(probes, offset, limit)

	if(len(p)>0):
		data['probes'][0]['requested']=len(p)
		data['probes'][0]['value']=','.join(map(str,p))
		print json.dumps(data)

		#response = cStringIO.StringIO()

		while(True):
			b = Buff()
			c = pycurl.Curl()
			c.setopt(c.WRITEFUNCTION, b.body_callback)
		#c.setopt(pycurl.SSLVERSION, pycurl.SSLVERSION_TLSv1)
			c.setopt(pycurl.URL, atlas_url)
			c.setopt(pycurl.HTTPHEADER, ['Content-Type: application/json','Accept: application/json'])
			c.setopt(pycurl.POST, 1)
			c.setopt(pycurl.POSTFIELDS, json.dumps(data))
			c.perform()
			c.close()
		#r=response.getvalue()
		#print r:wq
			print b.contents
			rjson = json.loads(b.contents)
			if(rjson.has_key("error")):
				time.sleep(60)
			else:
				m.extend(rjson['measurements'])
				break
		#print rjson['measurements']
	else:
		break

open(m_file, 'w').write(json.dumps(m))


#print response.getvalue()






#answer_json = c.perform()

#c.perform()

#c.close()

#print response.getvalue()
