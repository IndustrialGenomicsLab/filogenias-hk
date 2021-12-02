use strict;
# perl pFAM-parser.pl 358986.faa.out 
my $file=$ARGV[0];
#my $pfam=$ARGV[1];
my %Domains;

print "hello world\n";

open (FILE,$file) or die;

my $domain="";
foreach my $line (<FILE>){
	chomp $line;
	if($line=~m/Accession:/){
	$line=~s/Accession:\s*//;
		$domain=$line;
		}
	if($line=~m/>>/){
		$line=~s/>>//;
		$line=~s/\s*//g;
		print "$line\n";
		$Domains{$domain}.="_".$line;
		}
	
}
close FILE;

foreach my $key(keys %Domains){
	open(FILE,">$file-$key");
	my @sp=split("_",$Domains{$key});

	foreach my $elem(@sp){print FILE "$elem\n";}

	}

