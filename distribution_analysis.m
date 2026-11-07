% 创建新的图形窗口
figure;
set(gcf, 'Color', 'w');                   % 背景设为白色
set(gcf, 'DefaultAxesFontName', 'Times New Roman'); % 全局字体
set(gcf, 'DefaultAxesFontSize', 18);      % 全局字号
set(gcf, 'Position', [100, 100, 1200, 900]); % 调整窗口大小

% 使用 tiledlayout 自动管理子图布局
numRows = 6;
numCols = 5;
tiledLayout = tiledlayout(numRows, numCols, 'TileSpacing', 'compact', 'Padding', 'compact');

% 读取Excel数据
[num, txt, raw] = xlsread('data/new_data_x_names.xlsx');
numVariables = 30
% 提取数值部分
x = num;  % xlsread已经自动提取了数值部分

% 定义需要使用量级标注法的变量索引
scientificVars = [];

% 需要最后绘制的变量索引
lastVars = [];

% 先绘制其他变量（排除最后4个特殊变量）
remainingOrder = setdiff(1:numVariables, lastVars); % 获取剩余变量索引
for i = remainingOrder
    nexttile; % 自动分配子图位置

    % 绘制直方图（绿色）和正态分布曲线（红色）
    histogram(x(:, i), 'Normalization', 'pdf', 'FaceColor', 'green', 'EdgeColor', 'none');
    hold on;

    % 计算并绘制正态分布曲线
    mu = mean(x(:, i));
    sigma = std(x(:, i));
    xi = linspace(min(x(:, i)), max(x(:, i)), 100);
    normDist = normpdf(xi, mu, sigma);
    plot(xi, normDist, 'r', 'LineWidth', 1.5);

    % 设置标签
    xlabel(['Variable ' num2str(i) ' value']);
    ylabel('Density');
    box on;
    hold off;

    % 判断是否需要使用量级标注法
    if ismember(i, scientificVars)
        ytickformat('%.1e');
    else
        ytickformat('%.1f');
    end
end

% 最后绘制特殊变量（占据最后一行）
for i = lastVars
    nexttile; % 自动分配到剩余位置

    % 绘制直方图（绿色）和正态分布曲线（红色）
    histogram(x(:, i), 'Normalization', 'pdf', 'FaceColor', 'green', 'EdgeColor', 'none');
    hold on;

    % 计算并绘制正态分布曲线
    mu = mean(x(:, i));
    sigma = std(x(:, i));
    xi = linspace(min(x(:, i)), max(x(:, i)), 100);
    normDist = normpdf(xi, mu, sigma);
    plot(xi, normDist, 'r', 'LineWidth', 1.5);

    % 设置标签
    xlabel(['Variable ' num2str(i) ' value'], 'FontSize', 18);
    ylabel('Density', 'FontSize', 18);

    box on;
    hold off;

    % 判断是否需要使用量级标注法
    if ismember(i, scientificVars)
        ytickformat('%.1e');
    else
        ytickformat('%.1f');
    end
end

% 统一调整所有子图的坐标轴范围（可选）
% axis([xmin xmax ymin ymax]);
