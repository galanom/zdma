set grid
set key inside top left
set xlabel 'Queue Depth'
#set xtics rotate by -25 offset -1.2,-0.2
set ylabel 'Throughput (MB/s)'
#set y2label 'Throughput (fps)'
set xrange [-0.5:10.2]
#set y2range [0:2848.3]
#set y2tics 0,500,2500

set style line 1 lc rgb '#f0f0f0' lt 1 lw 1 pt 7 pi -1 ps 0.5
set style line 2 lc rgb '#e0e0e0' lt 1 lw 1 pt 7 pi -1 ps 0.5
set style line 3 lc rgb '#d0d0d0' lt 1 lw 1 pt 7 pi -1 ps 0.5
set style line 4 lc rgb '#c0c0c0' lt 1 lw 1 pt 7 pi -1 ps 0.5
set style line 5 lc rgb '#b0b0b0' lt 1 lw 1 pt 7 pi -1 ps 0.5
set style line 6 lc rgb '#a0a0a0' lt 1 lw 1 pt 7 pi -1 ps 0.5
set style line 7 lc rgb '#909090' lt 1 lw 1 pt 7 pi -1 ps 0.5
set style line 8 lc rgb '#808080' lt 1 lw 1 pt 7 pi -1 ps 0.5
set style line 9 lc rgb '#707070' lt 1 lw 1 pt 7 pi -1 ps 0.5
set pointintervalbox 1

set style line 11 lc rgb '#ffffff' lt 1 dt 10 lw 1 pt 5 pi -1 ps 0.4
set style line 12 lc rgb '#e8e8e8' lt 1 dt 10 lw 1 pt 5 pi -1 ps 0.4
set style line 13 lc rgb '#d0d0d0' lt 1 dt 10 lw 1 pt 5 pi -1 ps 0.4
set style line 14 lc rgb '#c0c0c0' lt 1 dt 10 lw 1 pt 5 pi -1 ps 0.4
set style line 15 lc rgb '#b0b0b0' lt 1 dt 10 lw 1 pt 5 pi -1 ps 0.4
set style line 16 lc rgb '#a0a0a0' lt 1 dt 10 lw 1 pt 5 pi -1 ps 0.4
set style line 17 lc rgb '#909090' lt 1 dt 10 lw 1 pt 5 pi -1 ps 0.4
set style line 18 lc rgb '#808080' lt 1 dt 10 lw 1 pt 5 pi -1 ps 0.4
set style line 19 lc rgb '#707070' lt 1 dt 10 lw 1 pt 5 pi -1 ps 0.4


set style data linespoints

plot "data/throughput.plot" using 2:xtic(1) title "loopback" ls 1,\
			"" using 3 title "negative" ls 2,	\
			"" using 4 title "threshold" ls 3,	\
			"" using 5 title "contrast" ls 4,	\
			"" using 6 title "sharpen" ls 5,	\
			"" using 7 title "emboss" ls 6,		\
			"" using 8 title "outline" ls 7,	\
			"" using 9 title "gauss" ls 8,		\
			"" using 10 title "sobel" ls 9,		


