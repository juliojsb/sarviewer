#!/usr/bin/env python2
"""
Author        :Julio Sanz
Website       :www.elarraydejota.com
Email         :juliojosesb@gmail.com
Description   :Generate RAM graph from ram.dat file
Dependencies  :Python 2.x, matplotlib
Usage         :python ram.py
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
# Memory data arrays
free_mem = []
used_mem = []
buffer_mem = []
cached_mem = []

# ======================
# FUNCTIONS
# ======================

def generate_graph():
    with open('../../data/ram.dat', 'r') as csvfile:
        data_source = csv.reader(csvfile, delimiter=' ', skipinitialspace=True)
        for row in data_source:
            # [0] column is a time column
            # Convert to datetime data type
            a = datetime.strptime((row[0]),'%H:%M:%S')
            x.append((a))
            # The remaining columns contain data
            free_mem.append(str((int(row[1])/1024)+(int(row[4])/1024)+(int(row[5])/1024)))
            used_mem.append(str((int(row[2])/1024)-(int(row[4])/1024)-(int(row[5])/1024)))
            buffer_mem.append(str(int(row[4])/1024))
            cached_mem.append(str(int(row[5])/1024))
    
    # Plot lines
    plt.plot(x,free_mem, label='Free', color='g', antialiased=True)
    plt.plot(x,used_mem, label='Used', color='r', antialiased=True)
    plt.plot(x,buffer_mem, label='Buffer', color='b', antialiased=True)
    plt.plot(x,cached_mem, label='Cached', color='c', antialiased=True)
    
    # Graph properties
    plt.xlabel('Time',fontstyle='italic')
    plt.ylabel('Memory (MB)',fontstyle='italic')
    plt.title('RAM usage graph')
    plt.grid(linewidth=0.4, antialiased=True)
    plt.legend(loc='upper center', bbox_to_anchor=(0.5, -0.15), ncol=2, fancybox=True, shadow=True)
    plt.autoscale(True)
    
    # Graph saved to PNG file
    plt.savefig('../../graphs/ram.png', bbox_inches='tight')
    #plt.show()

# ======================
# MAIN
# ======================

if __name__ == '__main__':
    generate_graph()