import numpy as np
import matplotlib.pyplot as plt

solution = np.loadtxt("solution.txt", skiprows=2)

N = len(solution)
m = int(np.sqrt(N))

solution = solution.reshape((m, m))

plt.imshow(solution, cmap='jet', origin='lower', extent=[0, 1, 0, 1])
plt.colorbar(label='Solution')
plt.xlabel('x')
plt.ylabel('y')
plt.title('2D Poisson Equation Solution')

plt.savefig('solution.pdf', format='pdf')

plt.close()