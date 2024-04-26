#!/bin/bash

sudo chmod +x cmdtaggr
sudo chmod +x files/reset.sh
cp -r files ~/.cmdtaggr
sudo cp cmdtaggr /usr/bin
echo cmdtaggr has been installed successfully!
