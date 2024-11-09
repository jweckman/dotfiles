#!/usr/bin/env nu

# Kauppalehti dividend history
open --raw Osinkohistoria.csv
    | from csv --separator ';'
    | rename --column { 'Tuotto, %': tuotto }
    | select Osake Irtoamispäivä tuotto
    | where tuotto != ''
    | update tuotto {
        |x| $x | get tuotto
        | into string
        | str replace ',' '.'
        | into float
    }
    | group-by 'Osake'
    | transpose c d
    | update d {
        |x| ($x.d | math avg | get tuotto)
    }
    | sort-by d
    | rename --column {d: yield_avg, c: company}

