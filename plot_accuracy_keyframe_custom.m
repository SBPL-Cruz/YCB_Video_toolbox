function plot_accuracy_keyframe
   
    close all;

    max_distance = 0.1;
    max_distance_pose = 0.02;
    
% GT Box, fast_gicp, stride 8, < 2cm and AUC
% results_file = "./6dof_exp/fast_gicp/sugar_gicp_new_frob.txt" %98.64, 95.78
% results_file = "./6dof_exp/fast_gicp/cracker_gicp_new_frob.txt" %99.19, 94.79
% results_file = "./6dof_exp/fast_gicp/bowl_gicp_new_frob.txt" %100.00, 97.22
% results_file = "./6dof_exp/fast_gicp/bleach_gicp_new_frob.txt" %98.54, 95.03

% GT Box, fast_vgicp, stride 5, < 2cm and AUC
% results_file = "./6dof_exp/fast_vgicp/cracker_box.txt" %98.73, 93.41


    
%     
    % good 6dof
%     results_file = "./6dof/scissors_better.txt"
%         results_file = "./6dof/bleach_better.csv"
% results_file = "./6dof/052_clamp"
% results_file = "./6dof/051_large_clamp.txt"
% results_file = "./6dof/cb_temp"

% results_file = "./6dof/runtim_200";
%     results_file = "./symm_only_new_acc_1.txt"; % best run with all symm objects
%     results_file = "./6dof/symm_bowl_mordor.txt"; % bowl with occlusion specific centroid shifting
%     results_file = "./6dof/symm_can_2.txt";
%     results_file = "./6dof/symm_cup.txt";
%     results_file = "./6dof/symm_meat.txt"
%     results_file = "./6dof/symm_mustard_pitcher_psc.txt"
%     results_file = "./6dof/symm_foam.txt"
%     results_file = "./6dof/symm_wood_1.txt"
%     results_file = "./6dof/drill"
%     results_file = "./6dof/symm_sugar.txt"
%    results_file = "./6dof/banana.txt"
%    results_file = "./6dof/pitcher_base"
% results_file = "./6dof/symm_gelatin.txt"
% results_file = "./6dof/clamp" % mask-rcnn
% results_file = "./6dof/pudding.txt"

    % good 3dof 
%     method = "perch2.0";
%     method = "perch";
%     method = "dsope";
%     method = "bf_icp";
%     method = "perch2.0-a";
%     method = "perch-tree";
    % results_file = "./3dof/dope/combined_acc.csv";
    % results_file = "./3dof/perch/combined_acc.csv";
%     results_file = "./3dof/" + method + "/combined_acc.csv";
    % results_file = "./3dof/bf_icp/combined_acc.csv";
%     results_file = "./3dof/perch2.0-a/combined_acc.csv";
%      results_file = "./3dof/perch-tree/combined_acc.csv";
    
    
    [header, distances_sys, distances_non, distances_sys_all, num_objects] = readFile(results_file);
    max_plots = 13;
    makePlots(num_objects, distances_sys, max_distance, max_distance_pose, max_plots, header);
%     output_file = "./3dof/" + method + ".mat";
%     save(output_file,'distances_sys_all')


end


function [header, distances_sys, distances_non, distances_sys_all, num_objects] = readFile(results_file)
    fid = fopen(results_file);
    tline = fgetl(fid);
    header = strsplit(tline, ',');

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
                        distances_sys_all(count, 1) = str2double(data(i));
                    end     
                end

            end
        end
        tline = fgetl(fid);
        count = count + 1;
    end
    fclose(fid);
    num_objects = size(distances_sys, 2);
    
    header = header(2:1 + 2*num_objects);
end

function [] = makePlots(num_objects, distances_sys, max_distance, max_distance_pose, max_plots, header)
    color = {'r', 'y', 'g', 'b', 'm'};
    leng = {'Network Pose'};
    aps = zeros(5, 1);
    lengs = cell(5, 1);
    index_plot = [1];
    
    hf = figure('units','normalized','outerposition',[0 0 1 1]);
    font_size = 24;
    % for each class
    plot_i = 1;
    for k = 1:num_objects
        % distance symmetry
        i = 1;
        D = distances_sys(:, k);
        if ~any(D)
            continue;
        end
    %     Removing empty stuff
        D = D(D > 0);
        D_less = D(D < max_distance_pose);
        pose_percentage_sys(k) = numel(D_less)/numel(D) * 100.0;

        subplot(max_plots, 1, plot_i);
        plot_i = plot_i + 1;

        D(D > max_distance) = inf;
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

        fprintf("Pose percetnage for %s : %f\n", string(header(2*k)), pose_percentage_sys(k));
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
end