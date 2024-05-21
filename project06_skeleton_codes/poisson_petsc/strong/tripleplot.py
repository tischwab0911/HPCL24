import matplotlib.pyplot as plt
from collections import defaultdict
import numpy as np

# Function to read data from a file
def read_data_from_file(filename):
    execution_times = []
    solver_times = []
    setup_times = []
    ranks = []
    
    with open(filename, 'r') as file:
        lines = file.readlines()
        for line in lines:
            if line.strip():  # Ignore empty lines
                if "Execution time" in line:
                    time = float(line.split(': ')[1].split(' ')[0])
                    rank = int(line.split(': ')[2])
                    execution_times.append((rank, time))
                elif "Solver time" in line:
                    time = float(line.split(': ')[1].split(' ')[0])
                    solver_times.append((rank, time))
                elif "Setup time" in line:
                    time = float(line.split(': ')[1].split(' ')[0])
                    setup_times.append((rank, time))
    
    return execution_times, solver_times, setup_times

# Read the data from the file
filename = 'clean64-59410269.out'
execution_times, solver_times, setup_times = read_data_from_file(filename)

# Compute average times for each number of ranks
def compute_average_times(times):
    times_dict = defaultdict(list)
    for rank, time in times:
        times_dict[rank].append(time)
    avg_times = {rank: np.mean(t) for rank, t in times_dict.items()}
    return avg_times

avg_execution_times = compute_average_times(execution_times)
avg_solver_times = compute_average_times(solver_times)
avg_setup_times = compute_average_times(setup_times)

# Plotting
plt.figure(figsize=(10, 6))

x_exec = list(avg_execution_times.keys())
y_exec = list(avg_execution_times.values())
plt.plot(x_exec, y_exec, marker='o', label='Execution Time')

x_solver = list(avg_solver_times.keys())
y_solver = list(avg_solver_times.values())
plt.plot(x_solver, y_solver, marker='s', label='Solver Time')

x_setup = list(avg_setup_times.keys())
y_setup = list(avg_setup_times.values())
plt.plot(x_setup, y_setup, marker='^', label='Setup Time')

# Annotate each point with its runtime
def annotate_points(x, y):
    for i in range(len(x)):
        plt.annotate(f'{y[i]:.2f}', (x[i], y[i]), textcoords="offset points", xytext=(0,5), ha='center')

annotate_points(x_exec, y_exec)
annotate_points(x_solver, y_solver)
annotate_points(x_setup, y_setup)

plt.title('Strong Scaling Results')
plt.xlabel('Number of Ranks')
plt.ylabel('Average Time (seconds)')
plt.grid(True, which='both', linestyle='--', linewidth=0.5)
plt.xticks(sorted(set(x_exec) | set(x_solver) | set(x_setup)))  # Ensure we only use available ranks
plt.yscale('log')

plt.legend()

# Save the plot as a PDF file
plt.savefig('strong_scaling_results64-59410269.pdf', format='pdf')