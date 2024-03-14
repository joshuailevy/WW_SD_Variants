for file in vars/*
do
	fn="${file#*/}"
	echo $fn
	newFolder="vars-zipped/"
	fnZip="${newFolder}${fn}.tar.gz"
	echo $fnZip
	tar -czvf $fnZip $file
done
