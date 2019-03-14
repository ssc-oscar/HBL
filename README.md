# HartBleed - What is still vulnerable?


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

```

# References

The key commit:
https://git.openssl.org/gitweb/?p=openssl.git;a=commit;h=96db9023b881d7cd9f379b0c154650d6c108e9a3

https://nvd.nist.gov/vuln/detail/CVE-2014-0160

https:hartbleed.org