#metadata_finder
#A. Constantino Rodriguez
#04/10/2021

route=$(ls $1*region???.gbk)
total=$(ls $1*region???.gbk | wc -l)
step=0
echo $1
for datafile in $route
	do
	per=$(($step*100/$total))
	echo -ne $step of $total '['$per'%] working on file:'$datafile '\r'
	echo -ne '\n'
	step=$(($step+1))
	id=$(grep 'SEED:' $datafile | cut -d ':' -f2 | cut -d '"' -f1)
	organism=$(grep 'SOURCE' $datafile | cut -d ' ' -f7-)
	region=$(grep 'region_number=' $datafile | cut -d '"' -f2)
	type=$(grep 'candidate_cluster_number' $datafile -A7 | grep 'product' | cut -d '"' -f2 | sort | uniq)
	file0=$(grep 'ACCESSION' $datafile | cut -d ' ' -f4-)
	file1=$file0'_c'$region'.txt'
	file2=$1'/knownclusterblast/'$file1
	similar_cluster=$(grep -A1 'Significant hits' $file2 | tail -n 1 | cut -f 2-)
	for line in $id
		do
		gene=$(grep $line $datafile -A 10 | grep 'gene=' | cut -d '"' -f2 | head -n1)
		position=$(grep $line $datafile -B 73 | grep 'CDS' - | cut -d " " -f 19 | tail -n 1 | cut -d '(' -f 2 | cut -d ')' -f 1)
		strand=$(grep $line $datafile -B 73 | grep "CDS" - | cut -d ' ' -f 19 | tail -n1 | cut -d '(' -f 1)
		if [[ "$strand" == "complement" ]]
		then
		sense='-'
		else
		sense='+'
		fi
		echo -e $line'\t'$gene'\t'$organism'\t'$region'\t'$position'\t'$sense'\t'$type'\t'$similar_cluster'\t'$file0 | head >> $1/metadata.txt
	done
done
