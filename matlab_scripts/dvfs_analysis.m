%% DVFS + LMS Analysis Script
% Run this after your Simulink model is complete.

clc; clear;

%% 1) Set your model name
modelName = 'dvfs_zed_simple';  % <-- change to your final model file name (without .slx)

%% 2) Open and simulate the model
open_system(modelName);
disp('Running simulation...');
out = sim(modelName);   % assumes To Workspace blocks use 'out' structure or individual vars

disp('Simulation finished.');

%% 3) Extract signals (adjust names if needed)
% If your To Workspace blocks are inside "out", use out.xxx
if isfield(out,'u_log')
    u  = out.u_log;
else
    warning('u_log not found in output. Set u_log To Workspace in Simulink.');
    u = [];
end

if isfield(out,'pred_log')
    pred = out.pred_log;
else
    warning('pred_log not found.');
    pred = [];
end

if isfield(out,'p_state_log')
    p_state = out.p_state_log;
else
    warning('p_state_log not found.');
    p_state = [];
end

if isfield(out,'freq_log')
    freq = out.freq_log;
else
    freq = [];
end

if isfield(out,'power_log')
    power = out.power_log;
else
    power = [];
end

if isfield(out,'tout')
    t = out.tout;
else
    % if tout not present, create simple time vector
    t = (0:length(pred)-1).';
end

%% 4) Basic ranges and states
if ~isempty(u)
    min_u    = min(u);
    max_u    = max(u);
else
    min_u = NaN; max_u = NaN;
end

if ~isempty(pred)
    min_pred = min(pred);
    max_pred = max(pred);
else
    min_pred = NaN; max_pred = NaN;
end

if ~isempty(p_state)
    states_used = unique(p_state).';
    switches    = sum(diff(p_state) ~= 0);
else
    states_used = [];
    switches    = NaN;
end

%% 5) RMSE and "accuracy" of predictor
if ~isempty(u) && ~isempty(pred) && length(u) == length(pred)
    rmse     = sqrt(mean((double(pred) - double(u)).^2));
    accuracy = 1 - rmse;   % not real ML accuracy, but a simple normalized metric
else
    rmse = NaN; accuracy = NaN;
end

%% 6) Power metrics (if power_log available)
if ~isempty(power)
    adaptive_power = mean(power);
    % baseline: assume always highest p_state
    if ~isempty(p_state)
        % average power of samples where p_state = max
        max_state = max(p_state);
        baseline_power = mean(power(p_state == max_state));
    else
        baseline_power = adaptive_power;
    end

    power_saving = (baseline_power - adaptive_power) / baseline_power * 100;
else
    adaptive_power = NaN;
    baseline_power = NaN;
    power_saving   = NaN;
end

%% 7) Print summary in console
fprintf('\n===== DVFS + LMS MODEL METRICS =====\n');
fprintf('Min Workload        : %.4f\n', min_u);
fprintf('Max Workload        : %.4f\n', max_u);
fprintf('Min Predicted Load  : %.4f\n', min_pred);
fprintf('Max Predicted Load  : %.4f\n', max_pred);
fprintf('States Used         : %s\n', mat2str(states_used));
fprintf('State Transitions   : %d\n', switches);
fprintf('RMSE (Prediction)   : %.4f\n', rmse);
fprintf('Accuracy (1 - RMSE) : %.4f\n', accuracy);
fprintf('Baseline Power (mW) : %.4f\n', baseline_power);
fprintf('Adaptive Power (mW) : %.4f\n', adaptive_power);
fprintf('Power Saving (%%)    : %.2f%%\n', power_saving);

%% 8) Put metrics into a table (for report/paper)
Metrics = table;
Metrics.Min_Workload         = min_u;
Metrics.Max_Workload         = max_u;
Metrics.Min_Predicted_Load   = min_pred;
Metrics.Max_Predicted_Load   = max_pred;
Metrics.States_Used          = {states_used};
Metrics.State_Transitions    = switches;
Metrics.RMSE                 = rmse;
Metrics.Accuracy             = accuracy;
Metrics.Baseline_Power_mW    = baseline_power;
Metrics.Adaptive_Power_mW    = adaptive_power;
Metrics.Power_Saving_percent = power_saving;

disp(' ');
disp('=== Metrics table ===');
disp(Metrics);

%% 9) Plots – workload vs prediction, DVFS state, power

if ~isempty(u) && ~isempty(pred)
    figure;
    plot(t, u, 'LineWidth', 1.5); hold on;
    plot(t, pred, 'LineWidth', 1.5);
    title('Workload vs LMS Predicted Load');
    xlabel('Time (s)');
    ylabel('Value');
    legend('Workload (u)', 'Predicted (pred)');
    grid on;
end

if ~isempty(p_state)
    figure;
    stairs(t, double(p_state), 'LineWidth', 2);
    title('DVFS P-State Timeline');
    xlabel('Time (s)');
    ylabel('P-State (0=LOW,1=MED,2=HIGH)');
    yticks([0 1 2]);
    grid on;
end

if ~isempty(power)
    figure;
    plot(t, power, 'LineWidth', 2);
    title('Power Consumption Over Time');
    xlabel('Time (s)');
    ylabel('Power (mW)');
    grid on;
end

%% 10) Save figures as PNGs for report
% Uncomment if you want auto-save:
% print('dvfs_workload_vs_pred.png','-dpng','-r300');
% print('dvfs_pstate_timeline.png','-dpng','-r300');
% print('dvfs_power_timeline.png','-dpng','-r300');

disp('Analysis complete.');
