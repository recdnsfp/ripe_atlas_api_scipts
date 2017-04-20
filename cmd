wget http://ftp.ripe.net/ripe/atlas/probes/archive/2017/04/20170419.json.bz2
bunzip2 20170419.json.bz2
mkdir results
./create_measurement_all_probes.py measurement_tpl.json 20170419.json results_ids.json
# wait 5-10 min
./get_results.py results_ids.json results
./merge_results.py results_ids.json results merged.json
