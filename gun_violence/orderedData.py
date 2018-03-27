# coding: utf-8
import csv
import json
import glob
import math
from pprint import pprint
from datetime import datetime

months = {'January':1, 'February':2, 'March':3, 'April':4, 'May':5, 'June':6, 'July':7, 'August':8, 'September':9, 'October':10, 'November':11, 'December':12}
states = {}

heirarchy = { 'label':'root', 'children': [] }
for i in ['federal', 'rifle', 'rifle-handgun']:
    heirarchy['children'].append({'label': i,'children': []})
for i in ['under_18', '18-21', 'over_21']:
    for c in heirarchy['children']:
        c['children'].append({'label':i, 'children': []})
for i in ['injured', 'killed']:
    for c in heirarchy['children']:
        for a in c['children']:
            a['children'].append({'label': i, 'children': []})
for i in ['accidental','intentional']:
    for c in heirarchy['children']:
        for a in c['children']:
            for f in a['children']:
                f['children'].append({'label': i, 'perCapita': 0, 'absolute': 0})

rifleCapita = 0
bothCapita = 0
federalCapita = 0
with open('state_populations.csv', 'rb') as csvfile:
    reader = csv.reader(csvfile, delimiter=',', quotechar='|')
    for row in reader:
        name = row[0]
        if name != "State":
            states[name] = {
                'population':row[1],
                'law': 2 if (int(row[3]) == 1 and int(row[2]) == 1) else (1 if (int(row[3])==1 and int(row[2])==0) else 0)
                }
            if states[name]['law'] == 0: federalCapita += int(states[name]['population'])
            elif states[name]['law'] == 1: rifleCapita += int(states[name]['population'])
            else: bothCapita += int(states[name]['population'])

for file in glob.glob("json/*.json"):
    data = json.load(open(file))['incidents']
    category = 1 if file[5:15] == 'accidental' else 0

    for incident in data:
        d = incident['date'].split(' ')
        date = datetime.strptime(str(months[d[0]]) +'-' + d[1][:-1] + '-' + d[2], '%m-%d-%Y')
        cutoff_date = datetime.strptime('12-11-2017', '%m-%d-%Y')
        if len(incident) == 5 and date > cutoff_date: # has either age or age_group and is in the right age range
            state = incident['state']
            law = states[state]['law']
            for s in incident['shooters']:
                if len(s) > 0 and not (len(s) == 1 and s[s.keys()[0]] == 'Adult 18+'): #exclude empty results and 18+ since don't know which group they fall into
                    age_group = 0 # default to under 18
                    if s.keys()[0] == 'age':
                        if int(s[s.keys()[0]]) < 21:
                            age_group = 1
                        else:
                            age_group = 2
                    divisor = federalCapita if law == 0 else (rifleCapita if law == 1 else bothCapita)
                    heirarchy['children'][law]['children'][age_group]['children'][0]['children'][category]['perCapita'] += float(incident['killed'])/divisor
                    heirarchy['children'][law]['children'][age_group]['children'][1]['children'][category]['perCapita'] += float(incident['injured'])/divisor
                    heirarchy['children'][law]['children'][age_group]['children'][0]['children'][category]['absolute'] += float(incident['killed'])
                    heirarchy['children'][law]['children'][age_group]['children'][1]['children'][category]['absolute'] += float(incident['injured'])

with open('heirarchicalData.json', 'w') as outfile:
    #json.dumps(finalData, outfile, sort_keys=False, indent=4)
    json.dump(heirarchy, outfile)
