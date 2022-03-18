clear all
clc

% 初始参数
t = [0:0.001:24] % 代表从0点至24点
d_n = 180 % 天数（0-365）
D_n = [1:1:365]'
I_SC = 1367; % 地外太阳辐射强度常数
r_0 = 149597890; % 平均日地距离常数
phi = 30; % 纬度
epislon = 1/298.256; % 地球扁率
tau = 1; % 投射系数 无量纲

% 计算单位太阳辐射强度
alpha_day = 2 * pi * (d_n - 4)/365; % 天角数
r = r_0 * (1 - epislon^2) / (1 + epislon * cos(alpha_day)); % 日地距离
I_0n = I_SC * (r_0 / r)^2; % 地外太阳辐射强度
omega = pi - (pi * t / 12); % 时角
delta = (23.45 * pi / 180) * sind(360 * (284 + d_n) /365); % 太阳倾斜角
theta = pi / 2 - acos(sind(phi) * sin(delta) + cosd(phi) * cos(delta) * cos(omega)); % 天顶角

P_S = max(I_0n * tau * sin(theta), 0) % 单位面积太阳辐射强度
E_S = cumtrapz(t, P_S) % 单位面积太辐射总能量
P_AS = E_S(end) / 24

% Plot
plot(t, P_S)
hold on
refline([0 P_AS])
hold off
plot(t, E_S)

% 全年太阳辐射强度图谱
D_alpha_day = 2 * pi * (D_n - 4)/365; % 天角数
D_r = r_0 * (1 - epislon^2) ./ (1 + epislon .* cos(D_alpha_day)); % 日地距离
D_I_0n = I_SC .* (r_0 ./ D_r).^2; % 地外太阳辐射强度
D_omega = pi - (pi * t / 12); % 时角
D_delta = (23.45 * pi / 180) .* sind(360 * (284 + D_n) ./365); % 太阳倾斜角
D_theta = pi / 2 - acos(sind(phi) * sin(D_delta) + cosd(phi) * cos(D_delta) * cos(D_omega)); % 天顶角

D_P_S = max(D_I_0n * tau .* sin(D_theta), 0) % 单位面积太阳辐射强度
D_E_S = cumtrapz(t, D_P_S, 2) % 单位面积太辐射总能量
D_P_AS = D_E_S(:,end) / 24

% Plot3
mesh(t, D_n, D_P_S)
mesh(t, D_n, D_E_S)
plot(D_n, D_P_AS)


% 生成用于Simulink的数据
solar_radiation = [t'*3600, P_S']
