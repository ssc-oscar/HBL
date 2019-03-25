use strict;
use warnings;
use Date::Format;

my %mp;
open A, "zcat c2pHBNFull.map|";
while (<A>){
	chop();
   my ($fr, $to) = split(/;/);
   $mp{$fr} = $to;
}

my %cl;
open A, "p2tHBN";
while (<A>){
  chop();
  my ($p, @x) = split(/;/);
  $x[1] = time2str ("%Y-%m-%d",$x[1]);
  $x[2] = time2str ("%Y-%m-%d",$x[2]);
  my $s = join ';', ($p, @x);
  my $lc = $x[1];
  next if $lc eq ""; 
  $p =~ s|^https://github.com/||;   
  $p =~ s|^https://gitlab.com/|gl_|;   
  $p =~ s|^https://bitbucket.org/|bb_|; 
  $p =~ s|^https://repo.or.cz/|repo.or.cz_|;
  $p =~ s|^https://git.code.sf.net/p/|sourceforge.net_|;
  $p =~ s/\.git$//; 
  $p =~ s|/code$|| if $p =~ /^sourceforge.net_/;
  $p =~ s|/|_|;
  
  my $pre = "$p";
  $pre = "$mp{$p}" if defined $mp{$p};
  $cl{$pre}{$p}{c} = $s;
  $cl{$pre}{$p}{lc} = $lc;
}

for my $p (keys %cl){
  my @ps1 = sort { $cl{$p}{$b}{lc} cmp $cl{$p}{$a}{lc} } (keys %{$cl{$p}});
  print "$p;$cl{$p}{$ps1[0]}{c}\n";
}
  
