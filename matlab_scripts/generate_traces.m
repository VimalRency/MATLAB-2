% generate_traces.m
outdir = 'C:\projects\dvfs_zed\matlab_scripts\';
Ts = 0.1; Ttotal = 120;
t = (0:Ts:Ttotal-Ts)';
N = numel(t);

% A: bursty edge inference (bursts)
utilA = 0.2 + 0.2*sin(2*pi*0.05*t) + 0.4*(rand(size(t))>0.98).*(0.4+0.4*rand(size(t)));
utilA = min(max(utilA,0),1);

% B: steady medium
utilB = 0.45 + 0.05*sin(2*pi*0.02*t) + 0.05*randn(size(t));
utilB = min(max(utilB,0),1);

% C: compute heavy
utilC = 0.8 + 0.05*sin(2*pi*0.01*t) + 0.05*randn(size(t));
utilC = min(max(utilC,0),1);

writetable(table(t,utilA),'burst_tr.txt','Delimiter',',');
save(fullfile(outdir,'trace_bursty.mat'),'t','utilA','utilB','utilC');
% CSV form
csvwrite(fullfile(outdir,'trace_bursty.csv'),[t utilA])
csvwrite(fullfile(outdir,'trace_steady.csv'),[t utilB])
csvwrite(fullfile(outdir,'trace_heavy.csv'),[t utilC])
