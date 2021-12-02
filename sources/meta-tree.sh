#3/11/2021
#A Constantino
#gen_id_list metadata_list two_component_list

title=$(head $2 -n 1)
echo -e "$title"'\t'TCS'\t'TCS_gene'\t'Pfam >> $1'_meta.tsv'
cat $1 | cut -f 1 | sed 's/\r//' | while read id
	do
	gene=''
	status='orphan'
	strand=$(grep -hw $id $2 | cut -f 12)
	up=$(grep -hw $id $2 -B 1 | head -n 1 | cut -f 1)
	up_strand=$(grep -hw $id $2 -B 1 | head -n 1 | cut -f 12)
	down=$(grep -hw $id $2 -A 1 | tail -n 1 | cut -f 1)
	down_strand=$(grep -hw $id $2 -A 1 | tail -n 1 | cut -f 12)
	tcs1=$(grep -hw $up $3 | uniq )
	tcs2=$(grep -hw $down $3 | uniq)
	if [[ $tcs1 == ???* && $up_strand == $strand ]]; then
		gene=$tcs1
		status='tcs'
	elif [[ $tcs2 == ???* && $down_strand == $strand ]]; then
		gene=$tcs2
		status='tcs'
	else
		status='orphan'
	fi
	line=$(grep -w -h $id $2)
	echo -e "$line"'\t'$status'\t'"$gene" >> $1'_meta.tsv'
	done
