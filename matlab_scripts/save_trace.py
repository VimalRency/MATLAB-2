
import time, csv, psutil, argparse
parser = argparse.ArgumentParser()
parser.add_argument('--interval', type=float, default=0.1) # sampling period (s)
parser.add_argument('--duration', type=float, default=60)  # seconds
parser.add_argument('--out', type=str, default='trace.csv')
args = parser.parse_args()

t0 = time.time()
with open(args.out,'w',newline='') as f:
    w = csv.writer(f)
    w.writerow(['t','util'])
    while time.time()-t0 < args.duration:
        util = psutil.cpu_percent(interval=None) / 100.0
        w.writerow([time.time()-t0, util])
        time.sleep(args.interval)
