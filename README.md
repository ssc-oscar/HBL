# HartBleed - What is still vulnerable? What Really Happened?

The vulnerability in OpenSSL has been fixed, but how much code in
public repositories is still not fixed?

With WoC we set out to answer the question and provide ways to
contribute fixes.

First get all affected code staring from repositories containing the
two affected files:
```
for j in {0..31}
do zcat ../c2fb/c2fFull$ver$j.s | grep '[td]1_both\.c' | gzip > c2fHB$ver.$j.gz &
done
wait
echo c2fHB$ver.$j.gz
```

Now het projects for these commits and all commits in these projects
```
zcat c2fHBN.*.gz | cut -d\; -f1 | uniq | ~/lookup/Cmt2PrjShow.perl /fast/c2pFullN 1 32 | gzip > c2pHBN.gz
zcat c2pHBN.gz|perl -ane 'chop();s/^[^;]*;[^;]*;//;s/;/\n/g;print' | lsort 1G -u | gzip > pHBN.gz
zcat pHBN.gz | ~/lookup/Prj2CmtShow.perl /fast/p2cFullN 1 32 | gzip > p2cHBN.gz
```

Now get this larger set of commits and their attributes (time/author)
and use that to determine last commit and last commit affecting HB files:
```
zcat p2cHBN.gz|perl -ane 'chop();s/^[^;]*;[^;]*;//;s/;/\n/g;print' | lsort 10G -u |~/lookup/splitSec.perl p2cHBN.cs. 128
for j in {0..127..6}; do zcat c2taFullN$j.s | join -t\; - <(zcat p2cHBN.cs.$j.gz) | gzip > p2cHBN.c2ta.$j.gz; done
zcat p2cHBN.gz | perl getTime.perl  > p2tHBN
```

Now we can search these projects by first joining forks via shared commits:
```
zcat p2cHBN.gz|perl -ane 'chop();($p,$n,@cs)=split(/;/);for my $c (@cs) {print "$c;$p\n";}' | lsort 30G -t\; -k1b,2 -u | gzip > c2pHBNFull.gz
zcat c2pHBNFull.gz | perl $HOME/lookup/connectExportPre.perl | gzip > c2pHBNFull.p2p
zcat c2pHBNFull.p2p | perl $HOME/lookup/connectExportSrt.perl c2pHBNFull
zcat c2pHBNFull.versions1| ~/bin/connect | gzip > c2pHBNFul.clones
perl $HOME/lookup/connectImport.perl c2pHBNFull | gzip > c2pHBNFull.map

```

Then we can select the most recently active projects from each fork with no patch (by filtering on the last change of [td]1_both\.c):
```
perl map.perl   | sort -t\; -rk4 > unforked
```
The format is canonical name (for a fork), project url, number of commits, date of last commit (unix seconds), date of
last commit affecting  [td]1_both\.c, and number of authors.

Furthermore, we can find the original affected blobs for [td]1_both\.c and see where they may be now
```
```

# References

The key commit:
https://git.openssl.org/gitweb/?p=openssl.git;a=commit;h=96db9023b881d7cd9f379b0c154650d6c108e9a3

https://nvd.nist.gov/vuln/detail/CVE-2014-0160

https://hartbleed.org
