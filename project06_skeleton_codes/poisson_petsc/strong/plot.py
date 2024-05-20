import matplotlib.pyplot as plt
from collections import defaultdict
import numpy as np

# Function to read data from a file
def read_data_from_file(filename):
    times = []
    ranks = []
    with open(filename, 'r') as file:
        lines = file.readlines()
        for line in lines:
            if line.strip():  # Ignore empty lines
                parts = line.strip().split(', ')
                time = float(parts[0].split(': ')[1].split(' ')[0])
                rank = int(parts[1].split(': ')[1])
                times.append(time)
                ranks.append(rank)
    return times, ranks

# Read the data from the file
filename = 'poisson1-59390852.out'
times, ranks = read_data_from_file(filename)

# Compute average execution time for each number of ranks
execution_times = defaultdict(list)
for time, rank in zip(times, ranks):
    execution_times[rank].append(time)

avg_execution_times = {rank: np.mean(times) for rank, times in execution_times.items()}

# Plotting
plt.figure(figsize=(10, 6))
x = list(avg_execution_times.keys())
y = list(avg_execution_times.values())
plt.plot(list(avg_execution_times.keys()), list(avg_execution_times.values()), marker='o')

for i in range(len(x)):
    plt.annotate(f'{y[i]:.2f}', (x[i], y[i]), textcoords="offset points", xytext=(0,5), ha='center')


plt.title('Strong Scaling Results')
plt.xlabel('Number of Ranks')
plt.ylabel('Average Execution Time (seconds)')
plt.grid(True, which='both', linestyle='--', linewidth=0.5)
plt.xticks(list(avg_execution_times.keys()))  # Ensure we only use available ranks
plt.yscale('log')  # Optional: Log scale if there's a large range in execution times

plt.savefig('strong_scaling_results_on_1_node.pdf', format='pdf')