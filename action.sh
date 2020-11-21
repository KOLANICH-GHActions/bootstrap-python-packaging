#!/usr/bin/env bash

set -e;

THIS_SCRIPT_DIR=`dirname "${BASH_SOURCE[0]}"`; # /home/runner/work/_actions/KOLANICH-GHActions/bootstrap-python-packaging/master
THIS_SCRIPT_DIR=`realpath "${THIS_SCRIPT_DIR}"`;

for envVar in ${!ACTION_*};
do
	unset $envVar;
done;

for envVar in ${!GITHUB_*};
do
	unset $envVar;
done;

for envVar in ${!INPUT_*};
do
	unset $envVar;
done;

echo "##[group] Bootstrapping packaging: Clean up preinstalled setuptools";
	sudo rm -rf /usr/lib/python3/dist-packages/setuptools;
	sudo rm -rf /usr/lib/python3/dist-packages/setuptools-*.egg-info;	
echo "##[endgroup]";

echo "##[group] Bootstrapping packaging: Cloning ipi";
	git clone --depth=50 https://github.com/KOLANICH-tools/ipi.py;
echo "##[endgroup]";

cd ipi.py;
sudo python3 -m ipi bootstrap packaging;
sudo python3 -m ipi bootstrap itself;
