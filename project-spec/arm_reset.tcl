connect -url 147.27.39.174:3121
set items [split [targets] \n]
foreach line $items {
	set index [ scan $line %d]
	if {[string match "*ARM*" $line] == 1} {
		target $index
		rst
	}
}

