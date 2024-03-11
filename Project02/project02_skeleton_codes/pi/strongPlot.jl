using Plots

# data obtained from running on euler 
data_serial = [
    [2.49088227, 2.56414842, 2.53760201, 2.55492779, 2.53068041]
]

# data for 1 to 32 threads (using omp parallel and critical)
data_critical = [
    [2.32496477, 2.31395827, 2.27851791], # 1 Thread
    [0.94815415, 0.94415586, 0.76630158, 1.02378865, 1.24158534],
    [0.63241023, 0.66304532, 0.66935938, 0.57786704, 0.63090072],
    [0.33640933, 0.28806482, 0.33407765, 0.33796912, 0.34296345],
    [0.19032537, 0.13146164, 0.13084694, 0.13284536, 0.21523359],
    [0.18328987, 0.18315271, 0.16890340, 0.17190190, 0.18813482]
]

# data for 1 to 32 threads (using omp parallel for reduction)
data_reduction = [
    [2.30315919, 2.33400231, 2.25695089],
    [0.80869882, 0.64268321, 0.64253424, 0.64353040, 0.94576328],
    [0.60689613, 0.56593894, 0.50848665, 0.47639835, 0.46291790],
    [0.33912285, 0.34605271, 0.29679839, 0.26566171, 0.26762875],
    [0.23091496, 0.21177551, 0.21216936, 0.20783058, 0.22028002],
    [0.18510465, 0.15542691, 0.16385464, 0.15844109, 0.15730604]
]


threadsUsed = [1, 2, 4, 8, 16, 32]


scaling_critical = boxplot(threadsUsed, data_critical, xlabel="Number of Threads")
savefig(p, "strong_scaling_plot.png")

scaling_reduction = boxplot(threadsUsed, data_reduction, xlabel="Number of Threads")
savefig(p, "strong_scaling_plot.png")


