import csv
import math
import os
import matplotlib.pyplot as plt
import matplotlib.animation as animation

CSV_PATH = r"THE PATH TO YOUR .CSV"

COLUMN_TIME = "time"
REFRESH_MS = 500

def read_csv():
    if not os.path.exists(CSV_PATH):
        return None, {}
    with open(CSV_PATH, "r", newline="") as f:
        rows = list(csv.reader(f))
    if len(rows) < 2:
        return None, {}
    header = [h.strip() for h in rows[0]]
    data = {name: [] for name in header}
    for row in rows[1:]:
        if len(row) != len(header):
            continue
        for name, val in zip(header, row):
            try:
                data[name].append(float(val))
            except ValueError:
                data[name].append(float("nan"))
    return header, data

fig = plt.figure(figsize=(10, 8))
axes = []
current_cols = []

def update(frame):
    global axes, current_cols
    header, data = read_csv()
    if header is None or COLUMN_TIME not in data:
        return
    x = data[COLUMN_TIME]
    if not x:
        return

    plot_cols = [
        col for col in header
        if col != COLUMN_TIME and any(not math.isnan(v) for v in data[col])
    ]

    if not plot_cols:
        return

    if plot_cols != current_cols:
        current_cols = plot_cols
        fig.clf()
        n_graphs = len(current_cols)
        axes = fig.subplots(n_graphs, 1, sharex=True)
        if n_graphs == 1:
            axes = [axes]

    for ax, col in zip(axes, current_cols):
        ax.clear()
        ax.plot(x, data[col], label=col)
        ax.legend(loc="upper left")
        ax.grid(True)

    axes[-1].set_xlabel(f"{COLUMN_TIME} (s)")
    fig.suptitle("Live telemetry")
    fig.tight_layout()

ani = animation.FuncAnimation(fig, update, interval=REFRESH_MS, cache_frame_data=False)
plt.show()
