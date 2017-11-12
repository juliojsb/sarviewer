#!/bin/bash
#
# Script        :plotter.sh
# Author        :Julio Sanz
# Website       :www.elarraydejota.com
# Email         :juliojosesb@gmail.com
# Description   :Script to generate graphs in the folder graphs/ of this repository
# Dependencies  :sar,gnuplot
# Usage         :1)Give executable permissions to script -> chmod +x plotter.sh
#                2)Execute script -> ./plotter.sh
# License       :GPLv3
#

# Read sarviewer.properties file
. sarviewer.properties

if [ $# -ne 0 ];then
	echo "This script doesn't accept parameters"
elif [ "$graph_generator" == "gnuplot" ];then
	cd plotters/gnuplot
	gnuplot loadaverage.gplot
	gnuplot tasks.gplot
	gnuplot cpu.gplot
	gnuplot ram.gplot
	gnuplot swap.gplot
	gnuplot iotransfer.gplot
	gnuplot proc.gplot
	gnuplot contextsw.gplot
	gnuplot netinterface.gplot
	gnuplot sockets.gplot
elif [ "$graph_generator" == "matplotlib" ];then
	cd plotters/matplotlib
	python loadaverage.py
	python tasks.py
	python cpu.py
	python ram.py
	python swap.py
	python iotransfer.py
	python proc.py
	python contextsw.py
	python netinterface.py
	python sockets.py
else
	echo "Variable graph_generator must be \"gnuplot\" or \"matplotlib\", please check sarviewer.properties"
fi