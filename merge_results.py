#!/usr/bin/env python

import json
import sys

results = []
m_file = sys.argv[1]
results_dir = sys.argv[2]
output_file = sys.argv[3]

m = json.loads(open(m_file).read())

for input_file in m:
        results_slice = json.loads(open(results_dir+"/"+str(input_file)+".json").read())
        results.extend(results_slice)

print len(results)
open(results_dir+"/"+output_file, 'w').write(json.dumps(results))

