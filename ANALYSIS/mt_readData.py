__author__ = 'Marco Rüth'
"""
This script reads tables stored in csv-files
"""
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

# Read in table
data_raw = pd.read_csv('mtp_sub_1_night_1.csv')
data_raw = pd.DataFrame(data_raw)

# Inspect table columns
# print(data_raw.columns)
data_session = data_raw.groupby('Session')
# Inspect group values
#print(data_session.groups)

accuracy_sessions = data_session.get_group('Control')['Accuracy']
#print(accuracy_sessions)

tmp = data_session.get_group('Control')
#print(tmp)

ind = np.arange(len(data_session))
width = 0.5

acc_means = []
acc_xticks = []
acc_sem = []
for i, (sess, sessdata) in zip(range(len(data_session)), data_session):
    acc_means.append(np.mean(sessdata['Accuracy']))
    acc_sem.append(np.std(sessdata['Accuracy'])/np.sqrt(len(sessdata['Accuracy'])))
    acc_xticks.append(sess)

plt.bar(ind, acc_means, width, yerr=acc_sem, align='center')
plt.xticks(ind, acc_xticks)
plt.ylabel('Accuracy [in %]')
plt.title('Memory Performance across sessions')
plt.show()
"""

fig, ax = plt.subplots()
ax.bar(ind, (2, 3, 4), align='center')

plt.show()
"""