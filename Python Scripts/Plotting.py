

import pandas as pd
import matplotlib.pyplot as plt
import mplcursors

# Load the CSV file
df = pd.read_csv('nesa_test2.csv', sep=';')


# Select the columns
L_current = df['L_current'].tolist()
L_100ms = df['L_100ms'].tolist()
L_1s = df['L_1s'].tolist()


R_current = df['R_current'].tolist()
R_100ms = df['R_100ms'].tolist()
R_1s = df['R_1s'].tolist()

# Limit values to the range from 0 to 9.9e+18
L_current = [x for x in L_current]
L_100ms = [x for x in L_100ms ]
L_1s = [x for x in L_1s ]

R_current = [x for x in R_current]
R_100ms = [x for x in R_100ms ]
R_1s = [x for x in R_1s ]

# Create a figure with three subplots
fig, (ax1, ax2, ax3, ax4, ax5, ax6) = plt.subplots(1, 6, figsize=(80, 6))

# Plot the L_current values against the serial numbers in the first subplot
ax1.plot(range(1, len(L_current)+1), L_current)
ax1.set_xlabel('Serial Number')
ax1.set_ylabel('Value')
ax1.set_title('Line Graph of L_current Values')

# Plot the L_100ms values against the serial numbers in the second subplot
ax2.plot(range(1, len(L_100ms)+1), L_100ms)
ax2.set_xlabel('Serial Number')
ax2.set_ylabel('Value')
ax2.set_title('Line Graph of L_100ms Values')

# Plot the L_1s values against the serial numbers in the third subplot
ax3.plot(range(1, len(L_1s)+1), L_1s)
ax3.set_xlabel('Serial Number')
ax3.set_ylabel('Value')
ax3.set_title('Line Graph of L_1s Values')

# Plot the R_current values against the serial numbers in the first subplot
ax4.plot(range(1, len(R_current)+1), R_current)
ax4.set_xlabel('Serial Number')
ax4.set_ylabel('Value')
ax4.set_title('Line Graph of R_current Values')

# Plot the R_100ms values against the serial numbers in the second subplot
ax5.plot(range(1, len(R_100ms)+1), R_100ms)
ax5.set_xlabel('Serial Number')
ax5.set_ylabel('Value')
ax5.set_title('Line Graph of R_100ms Values')

# Plot the R_1s values against the serial numbers in the third subplot
ax6.plot(range(1, len(R_1s)+1), R_1s)
ax6.set_xlabel('Serial Number')
ax6.set_ylabel('Value')
ax6.set_title('Line Graph of R_1s Values')

mplcursors.cursor(hover=True)

# Show the plot
plt.show()