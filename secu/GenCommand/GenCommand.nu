#!/usr/bin/env nu


# this script generate a NuShell command. 
# this command is built from reading different type of security logs (suricata eve.json, certipy output) 
# generate quoted columns , plugs data hole, flatten cells that contains [].
# usages:
# GenCommand.nu eve.json -f eve
# use GenCommand.nu; GenCommand eve.json -f eve
use std
export def main [
  fichier: string, 
  --format (-f): string] string -> string {
  let commande_données = match $format {
      # date read from suricata eve.son file 
      "eve"  => {"open " + $fichier + "|where event_type == "alert"| flatten"},
      # date read from json file generated via "certipy find .."  
      "adcs" => {"open " + $fichier + "|get data|get properties"},
      _  => {"blanc"}
  }
  let données = match $format {
      "eve"  => (open $fichier | where event_type == "alert"| flatten),
      "adcs" => (open $fichier | get data|get properties)
  }

  let colonnes_quotées = $données |columns|each {$in |str replace -r '^' "'"}|each {$in |str replace -r '$' "'"}
  let commande_supprime_vides =  $colonnes_quotées |each {|it| $"default ($it|str replace "'" "'nodata-in-"|str join "-") ($it) \|"}| str join " "|str trim  --char '|'
  let commande_nettoyage =  $colonnes_quotées |each {|it| | $"update ($it) {$in |str join ';' }|"  }| str join " "|str trim  --char '|'
  let champs = ($colonnes_quotées | str join  " ")
  let commande_assemblée =  $commande_données + " |" + $commande_supprime_vides + "|" + $commande_nettoyage + "|" + "select -i " + $champs
  print $commande_assemblée
  let commande_fichier =  "let tableau = " + $commande_données + " |" + $commande_supprime_vides + "|" + $commande_nettoyage
  echo $commande_fichier|save -f commande.nu
  let commande_to_csv = $commande_assemblée + " | to csv | save -f result.csv"
  nu -c $commande_to_csv
}
