function [] = plot_multiple_accuracy()
    T1 = load('./3dof/perch2.0.mat');
    distances_sys_all(:,1) = T1(:);
%     T1 = load('./3dof/perch2.0-a.mat');
%     distances_sys_all(:,2) = T1(:);
%     T1 = load('./3dof/perch-tree.mat');
%     distances_sys_all(:,3) = T1(:);
    T2 = load('./3dof/perch.mat');
    distances_sys_all(:,2) = T2(:);
    T2 = load('./3dof/dope.mat');
    distances_sys_all(:,3) = T2(:);
    T2 = load('./3dof/bf_icp.mat');
    distances_sys_all(:,4) = T2(:);
%     T2 = load('./3dof/perch2.0-a.mat');
%     distances_sys_all(:,7) = T2(:);
    
%     color = {'r', 'o', 'b', 'm', 'g', 'p'};
%     leng = {'PERCH 2.0', 'PERCH 2.0 (A)', 'PERCH 2.0 (B)', 'PERCH', 'DOPE', 'BF-ICP'};
%     index_plot = [1, 2, 3, 4, 5, 6];

    color = {'r', 'b', 'm', 'y'};
    leng = {'PERCH 2.0', 'PERCH', 'DOPE', 'BF-ICP'};
    index_plot = [1, 2, 3, 4];

    aps = zeros(5, 1);
    lengs = cell(5, 1);
    close all;

    % load results
%     distances_sys = object.distances_sys;
%     distances_non = object.distances_non;
%     rotations = object.errors_rotation;
%     translations = object.errors_translation;
%     cls_ids = object.results_cls_id;

%     

    % read class names
%     fid = fopen('classes.txt', 'r');
%     C = textscan(fid, '%s');
%     classes = C{1};
%     classes{end+1} = 'All 21 objects';
%     fclose(fid);
%     classes = ["All"];

    hf = figure('units','normalized','outerposition',[0 0 1 1]);

    font_size = 24;
    max_distance = 0.1;


    for i = index_plot
        D = distances_sys_all(i);
        D = D.distances_sys_all;
        D = D(D > 0);
        D(D > max_distance) = inf;
        d = sort(D);
%         d(numel(d) + 1) = 0.11;
        n = numel(d);
        accuracy = cumsum(ones(1, n)) / n;  
        last = accuracy(numel(accuracy));
% 
%         for l = numel(accuracy):numel(accuracy) + 10
        l = numel(d);
        aps(i) = VOCap(d, accuracy);
        lengs{i} = sprintf('%s (%.2f)', leng{i}, aps(i) * 100);
        while d(numel(d)) < 0.095
            accuracy(l) = last;
            d(l) = d(l-1) + 0.005;
            l = l + 1;
        end
        plot(d, accuracy, color{i}, 'LineWidth', 4);
        
        hold on;
    end
    hold off;
    %h = legend('network', 'refine tranlation only', 'icp', 'stereo translation only', 'stereo full', '3d coordinate');
    %set(h, 'FontSize', 16);
    h = legend(lengs(index_plot), 'Location', 'southeast');
    set(h, 'FontSize', font_size);
    h = xlabel('ADD-S Threshold (m)');
    set(h, 'FontSize', font_size);
    h = ylabel('Accuracy');
    set(h, 'FontSize', font_size);
%     h = title(classes{k}, 'Interpreter', 'none');
%     set(h, 'FontSize', font_size);
    xt = get(gca, 'XTick');
    set(gca, 'FontSize', font_size)
%     ylim([0.0 1.])
    
end

function ap = VOCap(rec, prec)

    index = isfinite(rec);
    rec = rec(index);
    prec = prec(index)';

    mrec=[0 ; rec ; 0.1];
    mpre=[0 ; prec ; prec(end)];
    for i = 2:numel(mpre)
        mpre(i) = max(mpre(i), mpre(i-1));
    end
    i = find(mrec(2:end) ~= mrec(1:end-1)) + 1;
    ap = sum((mrec(i) - mrec(i-1)) .* mpre(i)) * 10;
end