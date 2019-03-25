# HartBleed - What is still vulnerable? What Really Happened?

The vulnerability in OpenSSL has been fixed, but how much code in
public repositories is still not fixed?

The following repositories might contain vulnerable code and have been modified recently, threfore may be in active use:

|name|url|Number of Commits|last commit|last ssl commit|Number of authors|
|----|---|---|---|---|
|nexe_nexe|https://github.com/nexe/nexe|853|2019-02-21|2012-11-30|71|
|zhgn_OpenBoard|https://github.com/OpenBoard-org/OpenBoard|3696|2019-02-20|2011-05-19|91|
|rZn_ad-away|https://github.com/AdAway/AdAway|1445|2019-02-16|2012-02-20|77|
|vvw_ssh2|https://github.com/mscdex/ssh2|999|2019-01-23|2012-08-07|69|
|bb_dilosdilos-illumos|https://bitbucket.org/dilosdilos-illumos|27580|2019-01-15|2014-09-11|1848|
|ly0_proxydroid|https://github.com/madeye/proxydroid|136|2018-12-19|2014-10-21|21|
|matsu_bitvisor|https://github.com/matsu/bitvisor|275|2018-12-19|2014-05-09|10|
|wangandmu_c|https://github.com/cSploit/android|1715|2018-12-17|2013-11-05|105|
|jmarco_eneboo|https://github.com/eneboo/eneboo-core|791|2018-12-16|2011-09-29|21|
|bb_RehabManclover|https://bitbucket.org/RehabManclover|5019|2018-11-09|2013-12-03|20|
|XuNazgul_cmpe295A|https://github.com/buaales/barrelfish-les|6089|2018-10-28|2012-05-08|74|
|kans_virgo|https://github.com/virgo-agent-toolkit/rackspace-monitoring-agent|8363|2018-10-15|2012-03-12|75|
|genba_CoreBitcoin|https://github.com/oleganza/CoreBitcoin|662|2018-10-10|2014-02-16|37|
|LuaDist_openssl|https://github.com/LuaDist/openssl|24|2018-08-08|2011-07-01|6|
|bb_dilosillumos-nexenta-mirror|https://bitbucket.org/dilosillumos-nexenta-mirror|19135|2018-08-07|2014-09-15|1817|
|mei3am_ps|https://github.com/zengge2/Psiphon3|15185|2018-07-25|2012-03-15|43|
|ehyea_coding|https://github.com/guoliqiang/coding|594|2018-07-18|2013-07-12|5|
|jief666_Clover|https://github.com/jief666/Clover|4516|2018-06-10|2013-12-03|21|
|hh_omnibus|https://github.com/opscode/omnibus|3574|2018-04-15|2010-08-18|230|
|bb_kbenginekbengine|https://bitbucket.org/kbenginekbengine|2128|2018-04-02|2012-04-03|6|
|tal-m_scapi|https://github.com/cryptobiu/scapi|3261|2018-01-08|2014-07-06|30|
|ezc_appengine-php|https://github.com/GoogleCloudPlatform/appengine-php|6|2018-01-08|2013-09-19|3|


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
