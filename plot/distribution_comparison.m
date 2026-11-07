% 创建新的图形窗口
figure;
set(gcf, 'Color', 'w');                   % 背景设为白色
set(gcf, 'DefaultAxesFontName', 'Times New Roman'); % 全局字体
set(gcf, 'DefaultAxesFontSize', 18);      % 全局字号
set(gcf, 'Position', [100, 100, 1200, 900]); % 调整窗口大小

% 使用 tiledlayout 自动管理子图布局
numRows = 5;
numCols = 6;
tiledLayout = tiledlayout(numRows, numCols, 'TileSpacing', 'compact', 'Padding', 'compact');

% 读取原始Excel数据
[num_orig, txt_orig, raw_orig] = xlsread('data/quyi_data_x_names.xlsx');
% 读取生成的数据
% [num_gen, txt_gen, raw_gen] = xlsread('data/CTGAN_data_multi.xlsx');
[num_gen, txt_gen, raw_gen] = xlsread('data/CTGAN_grouped_data_multi.xlsx');
% 确保只取生成数据中新生成的部分(假设原始数据在前，生成数据在后)
num_orig_rows = size(num_orig, 1);
num_gen = num_gen(num_orig_rows+1:end, :);

numVariables = 29;

% 定义需要使用量级标注法的变量索引
scientificVars = [];

% 需要最后绘制的变量索引 (如果有特殊处理的变量可以加入这里)
lastVars = [25, 26, 27, 28, 29]; % 假设这些是目标变量

% 先绘制其他变量（排除特殊变量）
remainingOrder = setdiff(1:numVariables, lastVars); % 获取剩余变量索引
for i = remainingOrder
    nexttile; % 自动分配子图位置

    % 绘制原始数据直方图（蓝色半透明）
    histogram(num_orig(:, i), 'Normalization', 'pdf', 'FaceColor', [0 0.4470 0.7410], 'FaceAlpha', 0.6, 'EdgeColor', 'none');
    hold on;

    % 绘制生成数据直方图（红色半透明）
    histogram(num_gen(:, i), 'Normalization', 'pdf', 'FaceColor', [0.8500 0.3250 0.0980], 'FaceAlpha', 0.6, 'EdgeColor', 'none');


    % % 绘制原始数据直方图（蓝色半透明）
    % histogram(num_orig(:, i), 'Normalization', 'pdf', 'FaceColor', [0 0.4470 0.7410], 'FaceAlpha', 0.6, 'EdgeColor', 'none');
    % hold on;

    % % 绘制生成数据直方图（红色半透明）
    % histogram(num_gen(:, i), 'Normalization', 'pdf', 'FaceColor', [0.8500 0.3250 0.0980], 'FaceAlpha', 0.6, 'EdgeColor', 'none');




    % 计算并绘制原始数据正态分布曲线
    mu_orig = mean(num_orig(:, i));
    sigma_orig = std(num_orig(:, i));
    x_range = linspace(min(min(num_orig(:, i)), min(num_gen(:, i))), ...
                       max(max(num_orig(:, i)), max(num_gen(:, i))), 100);
    normDist_orig = normpdf(x_range, mu_orig, sigma_orig);
    plot(x_range, normDist_orig, 'b-', 'LineWidth', 2);

    % 计算并绘制生成数据正态分布曲线
    mu_gen = mean(num_gen(:, i));
    sigma_gen = std(num_gen(:, i));
    normDist_gen = normpdf(x_range, mu_gen, sigma_gen);
    plot(x_range, normDist_gen, 'r-', 'LineWidth', 2);

    % 设置标签
    title(['X' num2str(i)], 'FontSize', 16);
    % 只在左侧和底部的图添加轴标签
    if mod(i-1, numCols) == 0
        ylabel('Density', 'FontSize', 16);
    end
    if i > (numRows-1)*numCols
        xlabel('Value', 'FontSize', 16);
    end

    % 添加图例（只在第一个子图中显示）
    % if i == remainingOrder(1)
    %     legend('Original Data', 'Generated Data', 'Original Fit', 'Generated Fit', 'FontSize', 14, 'Location', 'northoutside', 'Orientation', 'horizontal');
    % end
    if i == remainingOrder(1)
        legend('Original Data', 'Generated Data', 'Original Fit', 'Generated Fit', 'FontSize', 14, 'Location', 'northoutside', 'Orientation', 'vertical');
    end
    box on;
    grid on;

    % 判断是否需要使用量级标注法
    if ismember(i, scientificVars)
        ytickformat('%.1e');
    else
        ytickformat('%.1f');
    end
end

% 最后绘制特殊变量（如目标变量）
for i = lastVars
    nexttile; % 自动分配到剩余位置

    % 绘制原始数据直方图（蓝色半透明）
    histogram(num_orig(:, i), 'Normalization', 'pdf', 'FaceColor', [0 0.4470 0.7410], 'FaceAlpha', 0.6, 'EdgeColor', 'none');
    hold on;

    % 绘制生成数据直方图（红色半透明）
    histogram(num_gen(:, i), 'Normalization', 'pdf', 'FaceColor', [0.8500 0.3250 0.0980], 'FaceAlpha', 0.6, 'EdgeColor', 'none');

    % 计算并绘制原始数据正态分布曲线
    mu_orig = mean(num_orig(:, i));
    sigma_orig = std(num_orig(:, i));
    x_range = linspace(min(min(num_orig(:, i)), min(num_gen(:, i))), ...
                       max(max(num_orig(:, i)), max(num_gen(:, i))), 100);
    normDist_orig = normpdf(x_range, mu_orig, sigma_orig);
    plot(x_range, normDist_orig, 'b-', 'LineWidth', 2);

    % 计算并绘制生成数据正态分布曲线
    mu_gen = mean(num_gen(:, i));
    sigma_gen = std(num_gen(:, i));
    normDist_gen = normpdf(x_range, mu_gen, sigma_gen);
    plot(x_range, normDist_gen, 'r-', 'LineWidth', 2);

    % 设置标签
    title(['X' num2str(i)], 'FontSize', 16);
    % 只在左侧和底部的图添加轴标签
    if mod(i-1, numCols) == 0
        ylabel('Density', 'FontSize', 16);
    end
    if i > (numRows-1)*numCols
        xlabel('Value', 'FontSize', 16);
    end

    box on;
    grid on;

    % 判断是否需要使用量级标注法
    if ismember(i, scientificVars)
        ytickformat('%.1e');
    else
        ytickformat('%.1f');
    end
end

% 添加总标题
% title(tiledLayout, 'Distribution Comparison of Original and Generated Data', 'FontSize', 24);

% 保存图像
saveas(gcf, 'distribution_comparison.png');
saveas(gcf, 'distribution_comparison.fig');
