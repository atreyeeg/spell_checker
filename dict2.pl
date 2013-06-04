#Create the Dictionary
use IO::File;
use List::Util qw(max min);
#require dictionary.txt;


open FILE1, "dictionary.txt" or die $!;
my %dict;
my @alphabet=(a..z);
while( <FILE1> ) {
 chomp;
 my $line=$_;
# print "line:",$line,"\n";
 $dict{$line}=**;
}



#SUBROUTINES:
#============
sub cost
{
   #This function will not work for the numerics
	my($val1,$val2) = @_;
	my $cost = 0;
	if ($val1 eq $val2){
		$cost = 0;
	} else {
		$cost = 1;
	}
	return $cost;
}

sub min_val
{
my @array = @_;
my $min;

for (@array) {
    $min = $_ if !$min || $_ < $min;
   # $max = $_ if !$max || $_ > $max
};
#print "min = $min,\n";
return $min;
}

sub mismatch_pos
{
my ($s1,$s2)=@_;
my @s1 = split //,$s1;
my @s2 = split //,$s2;
my $mismatch_pos=0;
my $i = 0;
foreach  (@s1) {
    if ($_ ne $s2[$i]) {
       # print "$_, $s2[$i] $i\n";
	   $mismatch_pos=$i;
	   #print "inside mismatch_pos sub: $mismatch_pos \n" ;
	   return $mismatch_pos;
	   exit;
    }
    $i++;
}
#return $mismatch_pos;
}
sub forward_search
{
 my ($my_word,%dict_hash, @word_array) = @_; 
 my %local_hash,%local_hash2;
 #print " my word in sub : $my_word \n";
 #my @chars=split("", $my_word);
 #foreach my $key (@chars){
	for $key1 (sort keys %dict_hash){
		#print "inside 1st for key: $key1, \n";
		my $first = substr($my_word, 0, 1);
		if ($key1=~/^$first/){
			#print "inside if line 63 \n";
			$local_hash{$key1}="**";
		}
	}
	#print "inside 1st for \n";	
	for $key2 (sort keys %local_hash){
		#print "key 2 is:$key2,\n";
		my $mispos=mismatch_pos($my_word,$key2);
		my $reverse_word=reverse($my_word);
		my $reverse_key=reverse($key2);
		my $mispos_reverse=mismatch_pos($reverse_word,$reverse_key);
		#print "inside forward search sub: $mispos,\n" ;
		#print $mispos;
		my $prefix=substr($key2,0,$mispos);
		my $key_length=length($key2);
		my $suffix=substr($key2,($key_length-1),$mispos_reverse);
		#print "inside forward search sub suffix: $suffix,\n" ;
		#if (($key2=~/^$prefix/) && (length($key2) eq length($my_word))){
		if (($key2=~/^$prefix/) && ($key2=~/$suffix$/)){	
			push (@word_array,$key2);
			#print "inside if line 77 \n";
		}
	}
	#print @word_array,"\n";
    return @word_array;
}

sub edit_string_dist
{
	my ($my_word1,$my_word2,$dist) = @_; 
	my @str1arr = split(//, $my_word1);
	#print @str1arr;
	unshift @str1arr, 0;
	my $i=length($my_word1);
	my @str2arr = split(//, $my_word2);
	unshift @str2arr, 0;
	#print @str2arr;
	my $j=length($my_word2);
	my @arr1;
	my $temp=0;
	#Step 1:
	#ARRAY INITIALIZATION
	for(my $itr=0;$itr<=$i;$itr++) {
	
		$arr1[$itr][0]=$temp;
		#print "initial array content i wise",$arr1[$itr][0],"\n";
		#print "Row:0 Col:$itr = $arr1[$itr][0]\n";
		if($itr < $i) {
		#print "array : $str1arr[$itr+1] \n";
		}
		$temp++;
	}
	$temp=0;
	for(my $itr=0;$itr<=$j;$itr++) {
		
		$arr1[0][$itr]=$temp;
		#print "initial array content j wise",$arr1[0][$itr],"\n";
		#print "Row:$itr Col:0 = $arr1[0][$itr]\n";
		if($itr < $j) {
		#print "array : $str2arr[$itr+1] \n";
		}

		$temp++;
	}
#Print the array

#Calculate the distance using edit string algorithim
#Step 2: Fill in the matrix
	for(my $outerloop=1;$outerloop<=$i;$outerloop++) {
		for(my $innerloop=1;$innerloop<=$j;$innerloop++) {
			my $final_cost=cost($str1arr[$outerloop],$str2arr[$innerloop]);
			#print "the val outerloop = $outerloop,inerloop=$innerloop,finalcost=$final_cost,\n";
			$arr1[$outerloop][$innerloop] = min_val ( $arr1[$outerloop][$innerloop-1] + 1,
												 $arr1[$outerloop-1][$innerloop] + 1,
												 $arr1[$outerloop-1][$innerloop-1] + $final_cost);
			#print "array =$arr1[$outerloop][$innerloop],\n";
		}
	}
#Step3: The final distance between the words
my $dist=$arr1[$i][$j];

#print "the distance is : $dist	,\n";
}
sub min_dist_word 
{
	my ($my_word_len,%my_hash,@my_word) = @_;
    my $min = min values %my_hash;
	my $flag=0;
	#print "min values is: $min word len is $my_word_len\n";
	#for $key1 (sort keys %my_hash){
	#	    print "inside min_dist_word sub key:$key1 =>val:$my_hash{$key1} \n";
	#	}
	#print $key1,"\n";
	
	foreach $key (sort {myfunction($a, $b)} keys %my_hash) {
		if ($min == $my_hash{$key}){
			#print "inside 1st if \n";
			if (length($key)==$my_word_len){
				push (@my_word,$key);
			#	print "inside 2nd if \n";
				$flag=1;
			}elsif(!$flag){
			#print "$key => $hash{$key}\n";
				push (@my_word,$key);
			#	print "inside else \n";
			}
		}	 
	}
	return @my_word;
}

sub myfunction
{
   return (shift(@_) cmp shift(@_));
}
sub process_word 
{
		my (@mispell_word) = @_;
		my $word_len;
		print "The misspelled words are: \n";
		#print "mispell word : @mispell_word \n";
		for (my $i=0;$i<=$#mispell_word;$i++) {
			print "$mispell_word[$i]: ";
			$word_len=length($mispell_word[$i]);
			
			my @arr;
			#print "word is: $mispell_word[$i] \n"; 
			my @arr1=forward_search($mispell_word[$i],%dict,@arr);
			#print "in main: @arr1 \n";
			my $dist=0;
			my @correct_word;
			my %correct_word;
			foreach my $key1 (@arr1) {
				my $final_dist=edit_string_dist($key1,$mispell_word[$i],$dist);
				if ($final_dist >=5) {
					#print "too much spell mistake please check manually.\n";
				} else {
					#print "inside else key : $key1 and final dist : $final_dist\n";
					#push(@correct_word,$key1);
					$correct_word{$key1}=$final_dist;
				}				
			}
			#print "the word length $word_len \n";
			#@correct_word=min_dist_word(%correct_word,@correct_word);
			@correct_word=min_dist_word($word_len,%correct_word,@correct_word);
			#for $key1 (sort keys %correct_word){
				#print "key:$key1 =>val:$correct_word{$key1} \n";
			#}
			
			print "@correct_word \n";
		}
}
#=============





print "Enter a sentence to check: \n";

my $input=<STDIN>;
print "\n \n";
chomp($input);
#my @input=$input;
#remove the "." from the end of the line
$input =~ s/[[:punct:]]//g;
my $lc_string=lc $input;
#print "input: $lc_string, \n";
my @word = split(/ /, $lc_string);
my @word_arry_same_len,@misspell_word;
for ( my $i=0;$i<=$#word;$i++){
	if (exists $dict{$word[$i]}) {
		#print "found word in dictionary \n";
	} else {
		#print "not found in dictionary check the spell \n";
		push (@misspell_word,$word[$i]);
	}
}	
#print @misspell_word;
process_word(@misspell_word);		
		
		
			
		
#for
=head
for $key1 (sort keys %dict){
			#print $key1,"\n";
			if ( $word_len == length($key1)){
				push(@word_arry_same_len,$key1);
			}
		}
=cut