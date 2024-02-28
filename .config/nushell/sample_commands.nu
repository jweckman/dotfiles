# Table string column does not contain filter
 ls **/* | sort-by size | where ($it.name | str contains --not .po)
