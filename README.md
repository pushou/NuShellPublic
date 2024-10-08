# Public NuShell Scripts 
## security
### GenCommand.nu script that generates a NuShell command.

#### prerequisites
- nu shell installed (0.96)
- jq installed
- Linux ? (not tested on Windows)
  
This command is built from reading different type of security logs :
- suricata eve.json
- certipy output


     
This script:
- generates quoted columns
- plugs data holes
- flatten cells that contains [].
- normalizes tables and permit csv output for further processing. 
- generate a /tmp/result.csv file where you can find the result of the command and import  it into a spreadsheet.
- generate a /tmp/command.nu file you can source:
```nu
    source /tmp/command.nu
    # use $tableau variable to process the data 
    $tableau|group-by flow_id? --to-table|where group == "587566051547044"|flatten
```
you can also copy-paste the result of the command into nu:
```nu 
GenCommand.nu eve.json -f eve
```
or
```nu
use GenCommand.nu ;GenCommand eve.json -f eve
```
results to copy paste:

open ../nushell/security-scripts/suricata/eve.json|where event_type == "alert"| flatten |default 'nodata-in-timestamp' 'timestamp' | default 'nodata-in-flow_id' 'flow_id' | default 'nodata-in-in_iface' 'in_iface' | default 'nodata-in-event_type' 'event_type' | default 'nodata-in-src_ip' 'src_ip' | default 'nodata-in-src_port' 'src_port' | default 'nodata-in-dest_ip' 'dest_ip' | default 'nodata-in-dest_port' 'dest_port' | default 'nodata-in-proto' 'proto' | default 'nodata-in-pkt_src' 'pkt_src' | default 'nodata-in-action' 'action' | default 'nodata-in-gid' 'gid' | default 'nodata-in-signature_id' 'signature_id' | default 'nodata-in-rev' 'rev' | default 'nodata-in-signature' 'signature' | default 'nodata-in-category' 'category' | default 'nodata-in-severity' 'severity' | default 'nodata-in-metadata' 'metadata' | default 'nodata-in-app_proto' 'app_proto' | default 'nodata-in-direction' 'direction' | default 'nodata-in-pkts_toserver' 'pkts_toserver' | default 'nodata-in-pkts_toclient' 'pkts_toclient' | default 'nodata-in-bytes_toserver' 'bytes_toserver' | default 'nodata-in-bytes_toclient' 'bytes_toclient' | default 'nodata-in-start' 'start' | default 'nodata-in-flow_src_ip' 'flow_src_ip' | default 'nodata-in-flow_dest_ip' 'flow_dest_ip' | default 'nodata-in-flow_src_port' 'flow_src_port' | default 'nodata-in-flow_dest_port' 'flow_dest_port' | default 'nodata-in-tx_id' 'tx_id' | default 'nodata-in-subject' 'subject' | default 'nodata-in-issuerdn' 'issuerdn' | default 'nodata-in-serial' 'serial' | default 'nodata-in-fingerprint' 'fingerprint' | default 'nodata-in-version' 'version' | default 'nodata-in-notbefore' 'notbefore' | default 'nodata-in-notafter' 'notafter' | default 'nodata-in-ja3' 'ja3' | default 'nodata-in-ja3s' 'ja3s' | default 'nodata-in-session_resumed' 'session_resumed' | default 'nodata-in-sni' 'sni' | default 'nodata-in-flowints' 'flowints' | default 'nodata-in-app_proto_tc' 'app_proto_tc' | default 'nodata-in-files' 'files' | default 'nodata-in-hostname' 'hostname' | default 'nodata-in-url' 'url' | default 'nodata-in-http_user_agent' 'http_user_agent' | default 'nodata-in-http_content_type' 'http_content_type' | default 'nodata-in-http_method' 'http_method' | default 'nodata-in-protocol' 'protocol' | default 'nodata-in-status' 'status' | default 'nodata-in-redirect' 'redirect' | default 'nodata-in-length' 'length' | default 'nodata-in-query' 'query' | default 'nodata-in-id' 'id' | default 'nodata-in-label' 'label' | default 'nodata-in-http_port' 'http_port' | default 'nodata-in-app_proto_ts' 'app_proto_ts' | default 'nodata-in-flowbits' 'flowbits' | default 'nodata-in-content_range' 'content_range' |update 'timestamp' {$in |str join ';' }| update 'flow_id' {$in |str join ';' }| update 'in_iface' {$in |str join ';' }| update 'event_type' {$in |str join ';' }| update 'src_ip' {$in |str join ';' }| update 'src_port' {$in |str join ';' }| update 'dest_ip' {$in |str join ';' }| update 'dest_port' {$in |str join ';' }| update 'proto' {$in |str join ';' }| update 'pkt_src' {$in |str join ';' }| update 'action' {$in |str join ';' }| update 'gid' {$in |str join ';' }| update 'signature_id' {$in |str join ';' }| update 'rev' {$in |str join ';' }| update 'signature' {$in |str join ';' }| update 'category' {$in |str join ';' }| update 'severity' {$in |str join ';' }| update 'metadata' {$in |str join ';' }| update 'app_proto' {$in |str join ';' }| update 'direction' {$in |str join ';' }| update 'pkts_toserver' {$in |str join ';' }| update 'pkts_toclient' {$in |str join ';' }| update 'bytes_toserver' {$in |str join ';' }| update 'bytes_toclient' {$in |str join ';' }| update 'start' {$in |str join ';' }| update 'flow_src_ip' {$in |str join ';' }| update 'flow_dest_ip' {$in |str join ';' }| update 'flow_src_port' {$in |str join ';' }| update 'flow_dest_port' {$in |str join ';' }| update 'tx_id' {$in |str join ';' }| update 'subject' {$in |str join ';' }| update 'issuerdn' {$in |str join ';' }| update 'serial' {$in |str join ';' }| update 'fingerprint' {$in |str join ';' }| update 'version' {$in |str join ';' }| update 'notbefore' {$in |str join ';' }| update 'notafter' {$in |str join ';' }| update 'ja3' {$in |str join ';' }| update 'ja3s' {$in |str join ';' }| update 'session_resumed' {$in |str `join ';' }| update 'sni' {$in |str join ';' }| update 'flowints' {$in |str join ';' }| update 'app_proto_tc' {$in |str join ';' }| update 'files' {$in |str join ';' }| update 'hostname' {$in |str join ';' }| update 'url' {$in |str join ';' }| update 'http_user_agent' {$in |str join ';' }| update 'http_content_type' {$in |str join ';' }| update 'http_method' {$in |str join ';' }| update 'protocol' {$in |str join ';' }| update 'status' {$in |str join ';' }| update 'redirect' {$in |str join ';' }| update 'length' {$in |str join ';' }| update 'query' {$in |str join ';' }| update 'id' {$in |str join ';' }| update 'label' {$in |str join ';' }| update 'http_port' {$in |str join ';' }| update 'app_proto_ts' {$in |str join ';' }| update 'flowbits' {$in |str join ';' }| update 'content_range' {$in |str join ';' }|select -i 'timestamp' 'flow_id' 'in_iface' 'event_type' 'src_ip' 'src_port' 'dest_ip' 'dest_port' 'proto' 'pkt_src' 'action' 'gid' 'signature_id' 'rev' 'signature' 'category' 'severity' 'metadata' 'app_proto' 'direction' 'pkts_toserver' 'pkts_toclient' 'bytes_toserver' 'bytes_toclient' 'start' 'flow_src_ip' 'flow_dest_ip' 'flow_src_port' 'flow_dest_port' 'tx_id' 'subject' 'issuerdn' 'serial' 'fingerprint' 'version' 'notbefore' 'notafter' 'ja3' 'ja3s' 'session_resumed' 'sni' 'flowints' 'app_proto_tc' 'files' 'hostname' 'url' 'http_user_agent' 'http_content_type' 'http_method' 'protocol' 'status' 'redirect' 'length' 'query' 'id' 'label' 'http_port' 'app_proto_ts' 'flowbits' 'content_range'

