#!/usr/bin/tclsh

set COUNT 0
array set PICS {}

cd assets

file delete {*}[glob -nocomplain thumb.**]

proc format_date {pic} {
  set tmp [lindex [regexp -inline -- {IMG_([0-9]+)_[0-9]+.[a-z]+} $pic] 1]
  set ms [clock scan $tmp]
  return [clock format $ms -format "%e %B" -locale el]
}

foreach pic [lsort -dictionary [glob **]] {
  set date [format_date $pic]
  set thumb \[thumb$::COUNT\]
  set img \[img$::COUNT\]
  puts "$img: assets/$pic"
  puts "$thumb: assets/thumb.$pic"
  lappend PICS($date) "\[!$thumb\]$img"
  exec convert -thumbnail 200 $pic thumb.$pic
  incr ::COUNT
}

puts ""

foreach d [lsort -dictionary [array names PICS]] {
  puts "## $d"
  puts ""

  foreach p $PICS($d) {
    puts "$p"
    puts ""
  }
}
