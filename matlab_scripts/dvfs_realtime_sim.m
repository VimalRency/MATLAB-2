%% REAL-TIME DVFS CONTROLLER (NO FPGA VERSION)
% This mimics AXI registers and hardware update loop

clc; clear; close all;

%% "Hardware Registers"
u_reg       = single(0);   % workload input (AXI write)
p_state_reg = uint8(1);    % DVFS state (AXI read)
pred_reg    = single(0);   % predictor output (AXI read)

%% Predictor state
prev = single(0);
W    = single(0.8);         % fixed W for hardware
bias = single(0.02);

%% FSM state
state        = uint8(1);
last_change  = uint32(0);
cycle_cnt    = uint32(0);
next_avail   = uint32(0);

% Thresholds
T1 = single(0.08);
T2 = single(0.26);
H  = single(0.02);

min_residency       = uint32(2);
transition_latency  = uint32(1);

%% Generate workload pattern (like real-time input)
t_total  = 10;              % 10 seconds
Ts       = 0.05;            % 20 Hz update rate
N        = t_total / Ts;

u_trace = single( ...
        0.3 + 0.2*sin(2*pi*(1:N)/60) ...     % slow variation
      + 0.15*randn(1,N));                    % random spike noise
u_trace = max(0, min(1, u_trace));           % clamp 0–1

%% Logging
u_log      = zeros(1,N,'single');
pred_log   = zeros(1,N,'single');
p_log      = zeros(1,N,'uint8');

%% REAL-TIME LOOP
figure;
for k = 1:N
    pause(Ts);     % <<< REAL-TIME FEEL (mimics hardware loop)

    %% ========== "CPU writes to AXI register" ==========
    u_reg = u_trace(k);

    %% ========== PREDICTOR (hardware mimic) ==========
    e = single(u_reg);
    pred = W*prev + bias;
    prev = u_reg;

    pred = max(0, min(1, pred));     % clamp
    pred_reg = pred;

    %% ========== DVFS FSM ========== 
    cycle_cnt = cycle_cnt + 1;
    desired = state;

    switch state
        case 0   % LOW
            if pred >= T1 + H,   desired = 1; end

        case 1   % MED
            if pred >= T2 + H,   desired = 2;
            elseif pred < T1-H, desired = 0;
            end

        case 2   % HIGH
            if pred < T2 - H,    desired = 1; end
    end

    if desired ~= state
        if (cycle_cnt - last_change) >= min_residency && ...
               cycle_cnt >= next_avail
            state = desired;
            last_change = cycle_cnt;
            next_avail  = cycle_cnt + transition_latency;
        end
    end

    p_state_reg = state;

    %% Logging
    u_log(k)    = u_reg;
    pred_log(k) = pred_reg;
    p_log(k)    = p_state_reg;

    %% LIVE PLOT
    subplot(3,1,1);
    plot(u_log(1:k),'LineWidth',1.5); ylabel('Workload u'); ylim([0 1]); grid on;

    subplot(3,1,2);
    stairs(double(p_log(1:k)),'LineWidth',2); ylabel('p\_state'); yticks([0 1 2]); grid on;

    subplot(3,1,3);
    plot(pred_log(1:k),'LineWidth',1.5); ylabel('Pred'); ylim([0 1]); xlabel('Time'); grid on;

    drawnow;
end

disp("Real-time mimic COMPLETED!");
