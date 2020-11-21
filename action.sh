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

echo "##[group] Bootstrapping packaging";
	git clone --depth=50 https://github.com/pypa/setuptools.git;
	git clone --depth=50 https://github.com/pypa/setuptools_scm.git;
	git clone --depth=50 https://github.com/pypa/pip.git;
	git clone --depth=50 https://github.com/pypa/wheel.git;
	git clone --depth=1 -b setuptools.egg-info https://github.com/KOLANICH-GHActions/bootstrap-python-packaging ./setuptools/setuptools.egg-info
	cd ./setuptools;
	PYTHONPATH=../wheel/src python3 ./setup.py bdist_wheel;
	PYTHONPATH=../pip/src sudo python3 -m pip install --upgrade --pre ./dist/*.whl;
	cd ../wheel;
	PYTHONPATH=./src python3 ./setup.py bdist_wheel;
	PYTHONPATH=../pip/src sudo python3 -m pip install --upgrade --pre ./dist/*.whl;
	cd ../pip;
	python3 ./setup.py bdist_wheel;
	PYTHONPATH=./src sudo python3 -m pip install --upgrade --pre ./dist/*.whl;
	cd ../setuptools_scm;
	python3 ./setup.py bdist_wheel;
	sudo python3 -m pip install --upgrade --pre ./dist/*.whl;
	cd ..;
	rm -rf ./pip ./wheel;
echo "##[endgroup]";

echo "##[group] Installing toml";
	git clone --depth=50 https://github.com/uiri/toml.git;
	cd ./toml;
	python3 ./setup.py bdist_wheel;
	sudo pip3 install --upgrade --pre ./dist/*.whl;
	cd ..;
	#sudo pip3 install --upgrade --pre ./setuptools_scm/dist/*.whl[toml];
	sudo pip3 install --upgrade --pre setuptools-scm[toml];
	rm -rf ./toml ./setuptools_scm
echo "##[endgroup]";

echo "##[group] Installing flit_core";
	git clone --depth=50 https://github.com/takluyver/flit.git;
	cd flit/flit_core;
	python3 -c "from flit_core import build_thyself;build_thyself.build_wheel('./')";
	sudo pip3 install --upgrade --pre ./*.whl;
	cd ../..;
	rm -rf ./flit;
echo "##[endgroup]";

echo "##[group] Installing build"
	git clone --depth=50 https://github.com/pypa/pep517.git;
	git clone --depth=50 https://github.com/pypa/build.git;

	cd pep517;
	PYTHONPATH=../build/src python3 -m build -xnw .;
	sudo pip3 install --upgrade --pre ./dist/*.whl;

	cd ../build;
	PYTHONPATH=./src python3 -m build -xnw .;
	sudo pip3 install --upgrade --pre ./dist/*.whl;
	cd ..;

	rm -rf ./pep517 ./build;
echo "##[endgroup]"

echo "##[group] This time setuptools with correct metadata"
	cd ./setuptools;
	rm -rf ./setuptools.egg-info ./build ./dist
	python3 -m build -xnw .;
	pip3 install --upgrade ./dist/*.whl;
	cd ..
	rm -rf ./setuptools
echo "##[endgroup]"
