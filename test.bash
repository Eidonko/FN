#!/usr/bin/env bash

settitle() { printf %s $'\033'"]2;$@"$'\007\033'"]1;$@"$'\007'; }

rm frac/*.ppm

#for i in `seq 1 32` ; do
x=0
for i in $(seq 0.01 0.01 16) ; do
	x=$((x+1))
	j=$(printf "%04d" $x)
    settitle "[-$i, $i] [-$i $i] 2000    'x*x-y*y-x+y'    '2*x*y+0.997'"
	#julia -$i $i -$i $i 2000 < input2
	#julia -$i $i -$i $i 2000 < input3
	julia -$i $i -$i $i 2000 'x*x-y*y-x+y' '2*x*y+0.997'
	cp frac.ppm frac/$j.ppm
done

convert -dither none -deconstruct -layers optimize    -delay 10   -loop 0  -resize 400x400 frac/*ppm poppo2.gif

gifsicle -O3 poppo2.gif --scale=0.8 -o poppo2gifsicled.gif

