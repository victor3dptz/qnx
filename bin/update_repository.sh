#!/bin/bash

repo=./
ls -1 $repo -I *.sh > $repo/index
cd $repo
tar cvf content.tgz  *.repdata *.qpm index

cat << 'EOL' > $repo/repository.qrm
<RDF:Description about="http://qnx.victor3d.com.br">
   <QPM:RepositoryManifest>
      <QPM:MaintainerIdentifier>QSSL</QPM:MaintainerIdentifier>
      <QPM:RepositoryIdentifier>Unsupported</QPM:RepositoryIdentifier>
      <QPM:RepositoryType>Archive Repository</QPM:RepositoryType>
      <QPM:RepositoryContent>
EOL
count=`ls -1 *.qpk |wc -l`
upd=`date +"%Y%m%d%H%M%S"`
cat >> $repo/repository.qrm <<EOF
	 <QPM:PackageCount>$count</QPM:PackageCount>
         <QPM:LastUpdate>$upd</QPM:LastUpdate>
EOF
cat << 'EOL' >> $repo/repository.qrm
         <QPM:RemovableMedia>No</QPM:RemovableMedia>
         <QPM:FileVersion>2.00</QPM:FileVersion>
      </QPM:RepositoryContent>

      <QPM:RepositoryDescription>
         <QPM:RepositoryName>QSSL&apos;s Unsupported Repository</QPM:RepositoryName>
	 <QPM:RepositoryUrl>http://qnx.victor3d.com.br/repository621a/repository.qrm</QPM:RepositoryUrl>
         <QPM:RepositoryHomeURL>http://qnx.victor3d.com.br/</QPM:RepositoryHomeURL>
         <QPM:RepositoryEmail/>
         <QPM:PackageList>index</QPM:PackageList>
         <QPM:RepositorySmallIcon/>
         <QPM:RepositoryLargeIcon/>
         <QPM:Summary>Collection of 3rd party packages and Open Source ports</QPM:Summary>
         <QPM:Description>Extra packages for QNX</QPM:Description>
         <QPM:SummaryUrl>http://qnx.victor3d.com.br/</QPM:SummaryUrl>
         <QPM:RepositoryAdvertise>http://qnx.victor3d.com.br/</QPM:RepositoryAdvertise>
      </QPM:RepositoryDescription>

      <QPM:PackageList>
         <QPM:Repository>
EOL

cd $repo
pkgs=`mktemp`
ls -1 *.qpk > $pkgs
while IFS='' read -r line || [[ -n "$line" ]]; do
list=`tar tf $line | grep MANIFEST`
list=${list::-9}
echo $line - $list
#sleep 1
cat >> $repo/repository.qrm <<EOF 
	    <QPM:Pkg file="$line" stability="Stable">$list</QPM:Pkg>
EOF

done < "$pkgs"
rm -f $pkgs

cat << 'EOL' >> $repo/repository.qrm 
         </QPM:Repository>
      </QPM:PackageList>
   </QPM:RepositoryManifest>
</RDF:Description>

EOL

echo "Done!"