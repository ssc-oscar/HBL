use strict;
use warnings;

my %c2t;
my %c2a;
for my $j (0..127){
  open A, "zcat p2cHBN.c2ta.$j.gz|"; 
  while (<A>){
    chop();
    my ($c, $t, $a) = split(/;/);
    $c2t{$c} = $t;
    $c2a{$c} = $a;
  }
}
my %c2f;
for my $j (0..31){
  open A, "zcat c2fHBN.$j.gz|";
  while (<A>){
    chop();
    my ($c, $f) = split(/;/);
    $c2f{$c} = $f;
  }
}

   

print STDERR "read times\n";

sub fixP {
  my $p = $_[0];
  my ($t, @rest) = split (/_/, $p);
  
  my $str = "https://github.com/$t/" . (join "_", @rest);
  if ($t eq "bb"){
    my $u = shift @rest;
    $str = "https://bitbucket.org/$u" . (join "_", @rest);
  }else{
    if ($t eq "gl"){
      my $u = shift @rest;
      $str = "https://gitlab.com/$u/" . (join "/", @rest);
    }else{
      my $u = shift @rest;
      if ($t eq "sourceforge.net"){
        $str = "https://git.code.sf.net/p/$u/code"
      }else{
        if ($t =~ /kde.org|bioconductor.org|repo.or.cz/){
          if ($t =~ /kde.org/){
            $t = "anongit.kde.org";
            $u = $u.".git";
            $str = "https://$t/$u";
          }
          if ($t =~ /bioconductor.org/){
            $t = "git.bioconductor.org";
            $str = "https://$t/$u" . (join "_", @rest);
          }
          if ($t =~ /repo.or.cz/){
            $u = $u.".git";
            $str = "https://$t/$u";
          }
        }
      }
    }
  }
  $str;
}

while (<STDIN>){
  chop();
  my ($p, $n, @cs) = split(/;/);
  my @ts = ();
  my @tsf = ();
  my %as = ();
  for my $c (@cs){
    push @ts, $c2t{$c} if defined $c2t{$c};
    push @tsf, $c2t{$c} if defined $c2t{$c} && defined $c2f{$c};
    $as{$c2a{$c}}++ if defined $c2a{$c};
  }
  @ts = sort { $a <=> $b }  @ts;
  @tsf = sort { $a <=> $b }  @tsf;
  my $na = scalar(keys %as);
  print "".(fixP($p)).";$n;$ts[$#ts];$tsf[$#tsf];$na\n";
}
