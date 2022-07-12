import sys
from matplotlib import pyplot as plt
from matplotlib import colors
import json
import argparse
import os

SAVE_PATH="./images"

class Results:
    def __init__(self):
        self.li = []
        
    def parse(self, json_obj):
        s = json_obj["ALL STATS"]["Sets"]
        throughput = s.get("Ops/sec", 0)
        latency = s.get("Latency",0)
        
        c = json_obj["configuration"]
        requests = c.get("requests", 0)
        port = c.get("port",0)
        self.li.append(Result(throughput, latency, requests, port))
            
    def throughput_list(self):
        values = []
        names = []
        for l in self.li:
            names.append(l.name)
            values.append(l.throughput)            
        return names, values
        
    def latency_list(self):
        values = []
        names = []
        for l in self.li:
            names.append(l.name)
            values.append(l.latency)
        return names, values
        
        
class Result:
    def __init__(self, throughput, latency, requests, port):
        self.throughput = throughput
        self.latency = latency
        self.requests = requests
        self.name = ""
        print("port", port)
        if port == 6379:
            self.name = "redis"
        if port == 6380:
            self.name = "df"
        if port == 11211:
            self.name = "memcached"


def graph(ax, x, y, title, y_title):
    # fig, ax = plt.subplots()
    ax.set_title(title)
    ax.set_ylabel(y_title)
    rect = ax.bar(x, y)
    c = list(colors.TABLEAU_COLORS.values())
    for i, r in enumerate(rect):
        r.set_color(c[i])



parser = argparse.ArgumentParser()
parser.add_argument("-o")
parser.add_argument("-f", nargs='+', required=True)
args = parser.parse_args()

files = args.f
save_file = args.o

results =  Results()
for file_name in files:
    f = open(file_name, 'r')
    json_load = json.load(f)    
    results.parse(json_load)

fig = plt.figure()
ax1 = fig.add_subplot(1, 2, 1)
ax2 = fig.add_subplot(1, 2, 2)

x, y = results.throughput_list()
graph(ax1, x, y, "Ops/sec", "Ops/sec")

x, y = results.latency_list()
graph(ax2, x, y, "Latency", "Latency")

if save_file is None:
    plt.show()
else:
    f = os.path.join(SAVE_PATH, save_file)
    print("save ", f)
    plt.savefig(f)

