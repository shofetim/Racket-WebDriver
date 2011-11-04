#! /bin/bash

echo 'I can currenlty only prepare the binaries for a Linux x64 setup with Chrome';
echo 'For more flexibility download the drivers  applicatable to your setup and place them in lib';
echo '----------------------------------------------------------------------';
echo 'Links:';
echo 'http://code.google.com/p/chromium/downloads/list';
wget http://chromium.googlecode.com/files/chromedriver_linux64_16.0.902.0.zip &&
for i in *.zip;
 do unzip $i;
    rm $i;
done;
echo 'Success!';
