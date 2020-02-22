function plot_accuracy_keyframe



color = {'r', 'y', 'g', 'b', 'm'};
leng = {'Network Pose'};
aps = zeros(5, 1);
lengs = cell(5, 1);
close all;

% load results
% object = load('results_keyframe.mat');
% distances_sys = object.distances_sys;
% distances_non = object.distances_non;

% rotations = object.errors_rotation;
% translations = object.errors_translation;
% cls_ids = object.results_cls_id;

index_plot = [1];

% read class names
% fid = fopen('classes.txt', 'r');
% C = textscan(fid, '%s');
% classes = C{1};
% classes{end+1} = 'All 21 objects';
% fclose(fid);

% results_file = "/media/aditya/A69AFABA9AFA85D9/Cruzr/code/DOPE/catkin_ws/src/perception/sbpl_perception/src/scripts/tools/fat_dataset/model_outputs_test/accuracy_6d_1581795428.txt"

% results_file = "./symm_icp_max.txt";

% results_file = "./symm_cup.txt";

% good
% results_file = "./symm_only_new_acc_1.txt"; % best run with all symm objects
% results_file = "./symm_bowl_mordor.txt"; % bowl with occlusion specific centroid shifting
% results_file = "./symm_can_2.txt";
% results_file = "./symm_cup.txt";
% results_file = "./symm_meat.txt"

% this has 49, 52, 53 done
results_file = "./symm_mustard_pitcher_psc.txt"

fid = fopen(results_file);
tline = fgetl(fid);
header = strsplit(tline, ',');
header = header(2:numel(header)-1);

num_objects = numel(header)/2;
distances_sys = zeros(1, num_objects);
distances_non = zeros(1, num_objects);
max_plots = 7;

count = 1;
while ischar(tline)
    disp(tline);
    data = strsplit(tline, ',');
    data = regexp(tline,',','split');
    if count > 1
        for i = 2:numel(data)
            if ~isnan(str2double(data(i)))
                if mod(i, 2) == 0
                    distances_non(count, i/2) = str2double(data(i));
                else
                    distances_sys(count, fix(i/2)) = str2double(data(i));
                end     
            end

        end
    end
    tline = fgetl(fid);
    count = count + 1;
end
fclose(fid);

hf = figure('units','normalized','outerposition',[0 0 1 1]);
font_size = 24;
max_distance = 0.1;

% for each class
plot_i = 1;
for k = 1:num_objects
%     index = find(cls_ids == k);
%     if isempty(index)
%         index = 1:size(distances_sys,1);
%     end
%     index = k;

    % distance symmetry
    
%     for i = index_plot
    i = 1;
    D = distances_sys(:, k);
    if ~any(D)
        continue;
    end
    D = D(D > 0);
    subplot(max_plots, 1, plot_i);
    plot_i = plot_i + 1;
    
    D(D > max_distance) = inf;
%     D(numel(D) + 1) = 0.0;
    d = sort(D);
%     d(numel(d) + 1) = 0.1;
    n = numel(d);
%   denotes the percentage of poses upto that index
    accuracy = cumsum(ones(1, n)) / n;        
    plot(d, accuracy, color{i}, 'LineWidth', 4);
    aps(i) = VOCap(d, accuracy);
    lengs{i} = sprintf('%s (%.2f)', leng{i}, aps(i) * 100);
    hold on;
%     end
    hold off;
    %h = legend('network', 'refine tranlation only', 'icp', 'stereo translation only', 'stereo full', '3d coordinate');
    %set(h, 'FontSize', 16);
    h = legend(lengs(index_plot), 'Location', 'southeast');
    set(h, 'FontSize', font_size);
    h = xlabel('Average distance threshold in meter (symmetry)');
    set(h, 'FontSize', font_size);
    h = ylabel('accuracy');
    set(h, 'FontSize', font_size);
    h = title(header(2*k), 'Interpreter', 'none');
    set(h, 'FontSize', font_size);
    xt = get(gca, 'XTick');
    set(gca, 'FontSize', font_size)

%     % distance non-symmetry
%     subplot(2, 2, 2);
%     for i = index_plot
%         D = distances_non(index, i);
%         D(D > max_distance) = inf;
%         d = sort(D);
%         n = numel(d);
%         accuracy = cumsum(ones(1, n)) / n;
%         plot(d, accuracy, color{i}, 'LineWidth', 4);
%         aps(i) = VOCap(d, accuracy);
%         lengs{i} = sprintf('%s (%.2f)', leng{i}, aps(i) * 100);        
%         hold on;
%     end
%     hold off;
%     %h = legend('network', 'refine tranlation only', 'icp', 'stereo translation only', 'stereo full', '3d coordinate');
%     %set(h, 'FontSize', 16);
%     h = legend(lengs(index_plot), 'Location', 'southeast');
%     set(h, 'FontSize', font_size);
%     h = xlabel('Average distance threshold in meter (non-symmetry)');
%     set(h, 'FontSize', font_size);
%     h = ylabel('accuracy');
%     set(h, 'FontSize', font_size);
%     h = title(classes{k}, 'Interpreter', 'none');
%     set(h, 'FontSize', font_size);    
%     xt = get(gca, 'XTick');
%     set(gca, 'FontSize', font_size)
%     
%     % rotation
%     subplot(2, 2, 3);
%     for i = index_plot
%         D = rotations(index, i);
%         d = sort(D);
%         n = numel(d);
%         accuracy = cumsum(ones(1, n)) / n;
%         plot(d, accuracy, color{i}, 'LineWidth', 4);
%         hold on;
%     end
%     hold off;
%     %h = legend('network', 'refine tranlation only', 'icp', 'stereo translation only', 'stereo full', '3d coordinate');
%     %set(h, 'FontSize', 16);
%     h = legend(leng(index_plot), 'Location', 'southeast');
%     set(h, 'FontSize', font_size);
%     h = xlabel('Rotation angle threshold');
%     set(h, 'FontSize', font_size);
%     h = ylabel('accuracy');
%     set(h, 'FontSize', font_size);
%     h = title(classes{k}, 'Interpreter', 'none');
%     set(h, 'FontSize', font_size);
%     xt = get(gca, 'XTick');
%     set(gca, 'FontSize', font_size)
% 
%     % translation
%     subplot(2, 2, 4);
%     for i = index_plot
%         D = translations(index, i);
%         D(D > max_distance) = inf;
%         d = sort(D);
%         n = numel(d);
%         accuracy = cumsum(ones(1, n)) / n;
%         plot(d, accuracy, color{i}, 'LineWidth', 4);
%         hold on;
%     end
%     hold off;
%     h = legend(leng(index_plot), 'Location', 'southeast');
%     set(h, 'FontSize', font_size);
%     h = xlabel('Translation threshold in meter');
%     set(h, 'FontSize', font_size);
%     h = ylabel('accuracy');
%     set(h, 'FontSize', font_size);
%     h = title(classes{k}, 'Interpreter', 'none');
%     set(h, 'FontSize', font_size);
%     xt = get(gca, 'XTick');
%     set(gca, 'FontSize', font_size)
%     
%     filename = sprintf('plots/%s.png', classes{k});
%     hgexport(hf, filename, hgexport('factorystyle'), 'Format', 'png');
end

function ap = VOCap(rec, prec)

index = isfinite(rec);
% actual pose error
rec = rec(index);
% percentage of poses with that error
prec = prec(index)';

mrec=[0 ; rec ; 0.1];
mpre=[0 ; prec ; prec(end)];
for i = 2:numel(mpre)
    mpre(i) = max(mpre(i), mpre(i-1));
end
i = find(mrec(2:end) ~= mrec(1:end-1)) + 1;
ap = sum((mrec(i) - mrec(i-1)) .* mpre(i)) * 10;