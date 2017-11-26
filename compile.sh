if [ $# -lt "1" ]; then
	echo "Name of the unit to build needed."
else
	./make.sh < build_list.txt
	ghdl -e --ieee=synopsys -fexplicit "$1"
	echo "Unit $1 built!"
fi
