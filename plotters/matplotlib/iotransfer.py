#!/usr/bin/env python2
"""
Author        :Julio Sanz
Website       :www.elarraydejota.com
Email         :juliojosesb@gmail.com
Description   :Script to create a IO transfer (blocks written/read per second) graph
Dependencies  :Python 2.x, matplotlib
Usage         :python iotransfer.py
License       :GPLv3
"""

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt 
import csv
from datetime import datetime
import matplotlib.dates

# ======================
# VARIABLES
# ======================

# Aesthetic parameters
plt.rcParams.update({'font.size': 8})
plt.rcParams['lines.linewidth'] = 1.5
time_format = matplotlib.dates.DateFormatter('%H:%M:%S')
plt.gca().xaxis.set_major_formatter(time_format)
plt.gcf().autofmt_xdate()

# Time (column 0)
x = []
# Data arrays
b_read_second = []
b_written_second = []

# ======================
# FUNCTIONS
# ======================

def generate_graph():
    with open('../../data/iotransfer.dat', 'r') as csvfile:
        data_source = csv.reader(csvfile, delimiter=' ', skipinitialspace=True)
        for row in data_source:
            # [0] column is a time column
            # Convert to datetime data type
            a = datetime.strptime((row[0]),'%H:%M:%S')
            x.append((a))
            # The remaining columns contain data
            b_read_second.append(row[4])
            b_written_second.append(row[5])
            
    # Plot lines
    plt.plot(x,b_read_second, label='Blocks read per second', color='r', antialiased=True)
    plt.plot(x,b_written_second, label='Blocks written per second', color='g', antialiased=True)
    
    # Graph properties
    plt.xlabel('Time',fontstyle='italic')
    plt.ylabel('Blocks per second',fontstyle='italic')
    plt.title('IO Transfer graph')
    plt.grid(linewidth=0.4, antialiased=True)
    plt.legend(loc='upper center', bbox_to_anchor=(0.5, -0.15), ncol=2, fancybox=True, shadow=True)
    plt.autoscale(True)
    
    # Graph saved to PNG file
    plt.savefig('../../graphs/iotransfer.png', bbox_inches='tight')
    #plt.show()

# ======================
# MAIN
# ======================

if __name__ == '__main__':
    generate_graph()