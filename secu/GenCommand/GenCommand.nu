#!/usr/bin/env nu


# this script generate a NuShell command. 
# this command is built from reading different type of security logs (suricata eve.json, certipy output) 
# generate quoted columns , plugs data hole, flatten cells that contains [].
# use GenCommand.nu eve.json -f eve

def main [
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
  echo $commande_assemblée
  #nu -c $macommande
}
