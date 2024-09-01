#!/usr/bin/env nu

# prereq: jq
# this script generate a NuShell command. 
# this command is built from reading different type of security logs (suricata eve.json, certipy output) 
# generate quoted columns , plugs data hole, flatten cells that contains [].
# usages:
# GenCommand.nu eve.json -f eve
# use GenCommand.nu; GenCommand eve.json -f eve
# use GenCommand.nu; GenCommand  -f eve
# output : /tmp/commande.nu (source it to get $tableau)
# output : /tmp/result.csv (import it in libre office)



export def main [
  fichier: string, 
  --format (-f): string] string -> string {
  let nom_de_base = $fichier| path basename
  let commande_ml = if ($format|str starts-with 'eve') {"cat " +  $fichier + "|from json --objects|save -f /tmp/" + $nom_de_base} else {"cat " +  $fichier + "|save -f /tmp/" + $nom_de_base}
  nu -c  $commande_ml
  let fichier = "/tmp/" + $nom_de_base
  let commande_données = match $format {
      # date read from suricata eve.son file 
      "eveAlert"  => {"open " + $fichier + "|where event_type == "alert"| flatten"},
      "eveFlow"   => {"open " + $fichier + "|where event_type == "flow"| flatten"},
      "eveDns"    => {"open " + $fichier + "|where event_type == "données"| flatten"},
      "eve"       => {"open " + $fichier + "| flatten"},
      # date read from json file generated via "certipy find .."  
      "adcs"      => {"open " + $fichier + "|get data|get properties"}
  }
  #print $commande_données
  let données = match $format {
      "eveAlert"  => (open $fichier | where event_type == "alert"| flatten),
      "eveFlow"   => (open $fichier | where event_type == "flow"| flatten)
      "eveDns"    => (open $fichier | where event_type == "dns"| flatten)
      "eve"       => (open $fichier | flatten)
      "adcs"      => (open $fichier | get data|get properties)
  }

  let colonnes_quotées = $données |columns|each {$in |str replace -r '^' "'"}|each {$in |str replace -r '$' "'"}
  let commande_supprime_vides =  $colonnes_quotées |each {|it| $"default ($it|str replace "'" "'nodta-"|str join "-") ($it) \|"}| str join " "|str trim  --char '|'
  let commande_nettoyage =  $colonnes_quotées |each {|it| | $"update ($it) {$in |str join ';' }|"  }| str join " "|str trim  --char '|'
  let champs = ($colonnes_quotées | str join  " ")
  let commande_assemblée =  $commande_données + " |" + $commande_supprime_vides + "|" + $commande_nettoyage + "|" + "select -i " + $champs
  print $commande_assemblée
  let commande_fichier =  "let tableau = " + $commande_données + " |" + $commande_supprime_vides + "|" + $commande_nettoyage

  echo $commande_fichier|save -f /tmp/commande.nu
  let commande_to_csv =  $commande_assemblée + "|to csv|save -f /tmp/result.csv"
  
  nu -c $commande_to_csv
}
