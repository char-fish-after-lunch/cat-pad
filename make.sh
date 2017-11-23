module_name="cat_pad"
if [ $# -gt "0" ]; then
	module_name="$1"
fi

time=$(date -r "${module_name}-obj93.cf" +%s 2>/dev/null)
if [ $? -ne "0" ]; then
	time="0"
fi

echo $time

while read dep; do
	ntime=$(date -r "$dep" +%s 2>/dev/null)
	if [ $ntime -gt $time ]; then
		ghdl -a --work="$module_name" "$dep"
		echo "File $dep built"
	else
		echo "File $dep skipped"
	fi
done

