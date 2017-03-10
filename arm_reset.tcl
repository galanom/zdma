connect
set items [split [targets] \n]
foreach line $items {
	set index [ scan $line %d]
	if {[string match "*ARM*" $line] == 1} {
		target $index
		rst
	}
}

