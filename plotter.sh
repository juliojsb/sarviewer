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

# This variable can be "gnuplot" or "matplotlib" (Python) depending on how you want to generate the graphs
# By default, gnuplot
GRAPH_GENERATOR="gnuplot"

if [ $# -ne 0 ];then
	echo "This script doesn't accept parameters"
elif [ "$GRAPH_GENERATOR" == "gnuplot" ];then
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
elif [ "$GRAPH_GENERATOR" == "matplotlib" ];then
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
else
	echo "Variable GRAPH_GENERATOR must be \"gnuplot\" or \"matplotlib\", please check plotter.sh"
fi