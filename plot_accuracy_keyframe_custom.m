function plot_accuracy_keyframe
   
    close all;

    max_distance = 0.1;
    max_distance_pose = 0.02;
    
% GT Box, fast_gicp, stride 8, < 2cm and AUC
% results_file = "./6dof_exp/fast_gicp/sugar_gicp_new_frob.txt" %98.64, 95.78
% results_file = "./6dof_exp/fast_gicp/cracker_gicp_new_frob.txt" %99.19, 94.79
% results_file = "./6dof_exp/fast_gicp/bowl_gicp_new_frob.txt" %100.00, 97.22
% results_file = "./6dof_exp/fast_gicp/bleach_gicp_new_frob.txt" %98.54, 95.03

% Mask-RCNN BBOX, stride - 8
%  results_file = "./6dof_exp/fast_gicp_mask_rcnn/bleach.txt" %bleach - 100, 95.43
%  results_file = "./6dof_exp/fast_gicp_mask_rcnn/bowl.txt" %bowl - 100, 92.81
%  results_file = "./6dof_exp/fast_gicp_mask_rcnn/sugar_cracker.txt" %cracker - 99.42, 94.66, sugar - 98.55, 95.94
%  results_file = "./6dof_exp/fast_gicp_mask_rcnn/mustard_pitcher.txt" %mustard - 100, 97.49, pitcher - 100, 92.20
%  results_file = "./6dof_exp/fast_gicp_mask_rcnn/banana.txt" %banana - 100, 96.58 (object cloud created on gpu with stride)
%  results_file = "./6dof_exp/fast_gicp_mask_rcnn/chef_mug.txt" %chef - 100, 96.54, mug - 100, 97.12, mug with 0,1 sampling
%  results_file = "./6dof_exp/fast_gicp_mask_rcnn/gelatin.txt" %gelatin - 100, 96.31
%   results_file = "./6dof_exp/fast_gicp_mask_rcnn/meat_marker.txt" %marker - 100, 97.2, meat - 100, 95.3, meat missed in some images in 49, icp/total runtime difference high in end
%  results_file = "./6dof_exp/fast_gicp_mask_rcnn/soup.txt" %soup - 100, 97.26, missed in some images (reduce nearest neighbour)
%  results_file = "./6dof_exp/fast_gicp_mask_rcnn/pudding.txt" %pudding - 100, 93.47, increased sampling, one false positive
%  results_file = "./6dof_exp/fast_gicp_mask_rcnn/drill_more_sample_full.csv" %drill - 95.37, 99.33
%  results_file = "./6dof_exp/fast_gicp_mask_rcnn/sci_8_more_samples.txt" %100, 95.39
% Below are collected after changing the method of reading input (suspected)
%  results_file = "./6dof_exp/fast_gicp_mask_rcnn/extra_clamp.txt" %76.4, 85.12
%  results_file = "./6dof_exp/fast_gicp_mask_rcnn/clamp.txt" %98.52, 92.09
% stride - 5
%  results_file = "./6dof_exp/fast_gicp_mask_rcnn/tuna.txt" %tuna - 100, 95.79
%  results_file = "./6dof_exp/fast_gicp_mask_rcnn/foam.txt" %foam - 100, 96.25, has high runtime, 0,1 in sampling

% Bad Stuff
%  results_file = "./6dof_exp/fast_gicp_mask_rcnn/wood.txt" %wood - 90.99, 90.79
%  results_file = "./6dof_exp/fast_gicp_mask_rcnn/drill.txt" %drill - 84.011, 89.05
%  results_file = "./6dof_exp/fast_gicp_mask_rcnn/scissors_8.txt" %
%  results_file = "./6dof_exp/fast_gicp_mask_rcnn/sci_5.txt" %


% GT Box, fast_vgicp, stride 5, < 2cm and AUC
%  results_file = "./6dof_exp/fast_vgicp/cracker_box.txt" %98.73, 93.41
    
%     
% Good 6dof-IROS
%  results_file = "./6dof/scissors_better.txt"
%  results_file = "./6dof/bleach_better.csv"
%  results_file = "./6dof/052_clamp"
%  results_file = "./6dof/051_large_clamp.txt"
%  results_file = "./6dof/cb_temp"

% results_file = "./6dof/runtim_200";
%     results_file = "./6dof/symm_only_new_acc_1.txt"; % best run with all symm objects
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
%   method = "perch2.0";
%   method = "perch";
%   method = "dsope";
%   method = "bf_icp";
%   method = "perch2.0-a";
%   method = "perch-tree";
%   results_file = "./3dof/dope/combined_acc.csv";
%   results_file = "./3dof/perch/combined_acc.csv";
%   results_file = "./3dof/" + method + "/combined_acc.csv";
%   results_file = "./3dof/bf_icp/combined_acc.csv";
%   results_file = "./3dof/perch2.0-a/combined_acc.csv";
%   results_file = "./3dof/perch-tree/combined_acc.csv";
%   results_file = "./3dof_exp/soda_bottle/accuracy.txt" %drill - 84.011, 89.05
%   results_file = "./3dof_exp/soda_can/accuracy.txt" %drill - 84.011, 89.05

% crate
%   results_file = "./3dof_exp/crate/accuracy_cpu.csv";
%   results_file = "./3dof_exp/crate/accuracy_gpu.csv";
%   results_file = "./3dof_exp/crate/accuracy_gpu_full.txt";
%   results_file = "./3dof_exp/crate/accuracy_cpu_full.txt";
%   results_file = "./3dof_exp/crate/accuracy_gpu_full_psc.txt";
%   results_file = "./3dof_exp/crate/accuracy_gpu_full_psc_20.txt";
%   results_file = "./3dof_exp/crate/accuracy_gpu_full_psc_24_minn_65.txt";
%   results_file = "./3dof_exp/crate/accuracy_cpu_full_minn_65.txt";
%   results_file = "./3dof_exp/crate/accuracy_cpu_full_minn_75.txt";

% Conveyor
%   results_file = "./conveyor/sugar_gpu/sugar.txt"; %99.30, 90.97, 284
%   results_file = "./conveyor/sugar_gpu/sugar_new.txt"; %99.30, 91.06, 284, 0.0090
%   results_file = "./conveyor/mustard_gpu/mustard.txt"; %98.10, 91.63, 159
%   results_file = "./conveyor/mustard_gpu/mustard_new.txt"; %98.73, 91.70, 158, 0.0084
%   results_file = "./conveyor/drill_gpu/drill.txt"; %98.71, 91.13, 465
%   results_file = "./conveyor/drill_gpu/drill_new.txt"; %99.14, 91.42, 465, 0.0086
%   results_file = "./conveyor/soup_gpu/soup.txt"; %100, 94.85, 54, 0.0053

%   results_file = "./conveyor/sugar_cpu/sugar.txt"; %99.65, 91.20, 284, 0.0089
%   results_file = "./conveyor/mustard_cpu/mustard.txt"; %98.10, 91.93, 158, 0.0082
%   results_file = "./conveyor/drill_cpu/drill.txt"; %99.78, 91.60, 465, 0.0084
%   results_file = "./conveyor/soup_cpu/soup.txt"; %100, 94.18, 52, 0.0062

% Verification
%   results_file = "./verification/d3_new.txt";
%   results_file = "./verification/accuracy_24.txt";
%   results_file = "./verification/d3_new_new.txt"; %99.13, 91.42, 465
%   results_file = "./6dof_exp/fast_gicp_cuda/cracker.txt";
%   results_file = "./6dof_exp/fast_gicp_cuda/sugar.txt";
%   results_file = "./verification/cracker_gpu_cloud_cuda.txt";
% %   results_file = "./6dof_exp/fast_gicp_cuda_refactor/cracker.txt"; %new knn, separate gpu  icp
%   results_file = "./6dof_exp/fast_gicp_cuda_refactor/bleach_scissors_bowl.txt"; %new knn, separate gpu  icp
%   results_file = "./6dof_exp/fast_gicp_cuda_refactor/5_objects.txt"; %knn segmented, integrated gpu icp
%   results_file = "./verification/cracker_integrated_3dof.txt";

% 6dof - gpu icp , new segmented knn, code refactor, maskrcnn
%     results_file = "./6dof_exp/fast_gicp_cuda_integrated/cracker.txt"; %icp max dist - 0.05
%     icp max dist - 0.15
%     results_file = "./6dof_exp/fast_gicp_cuda_integrated/drill.txt";
%     results_file = "./6dof_exp/fast_gicp_cuda_integrated/mustard_pitcher.txt";
%     results_file = "./6dof_exp/fast_gicp_cuda_integrated/sugar.txt";
%     results_file = "./6dof_exp/fast_gicp_cuda_integrated/bleach.txt";
%     results_file = "./6dof_exp/fast_gicp_cuda_integrated/bowl.txt";
%     results_file = "./6dof_exp/fast_gicp_cuda_integrated/mug_foam.txt";
%     results_file = "./6dof_exp/fast_gicp_cuda_integrated/scissors_banana.txt";
%     results_file = "./6dof_exp/fast_gicp_cuda_integrated/wood.txt";
%     results_file = "./6dof_exp/fast_gicp_cuda_integrated/soup.txt"; %reduce min points to 20
%     results_file = "./6dof_exp/fast_gicp_cuda_integrated/chef_gelatin.txt";
%     results_file = "./6dof_exp/fast_gicp_cuda_integrated/marker.txt"; %reduce min points to 15
%     results_file = "./6dof_exp/fast_gicp_cuda_integrated/clamps.txt"; 
%     results_file = "./6dof_exp/fast_gicp_cuda_integrated/pudding.txt";  %reduce min points to 20
%     results_file = "./6dof_exp/fast_gicp_cuda_integrated/meat.txt";  %reduce min points to 20
%     results_file = "./6dof_exp/fast_gicp_cuda_integrated/tuna.txt";  %reduce stride to 5
    
% 6dof - gpu icp , new segmented knn, code refactor, posecnn
%     results_file = "./6dof_exp/fast_gicp_cuda_integrated_posecnn/file_1.txt";  
%     results_file = "./6dof_exp/fast_gicp_cuda_integrated_posecnn/file_2.txt";  % 4 objects
%     results_file = "./6dof_exp/fast_gicp_cuda_integrated_posecnn/file_3.txt";  

% 6dof - gpu icp , new segmented knn, code refactor, GT mask
%     results_file = "./6dof_exp/fast_gicp_cuda_integrated_gt_mask/file_1.txt";  


    [header, distances_sys, distances_non, distances_sys_all, num_objects] = readFile(results_file);
    max_plots = 5;
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
        fprintf("Total count for %s : %f\n", string(header(2*k)), numel(D));

        D = D(D > 0);
        D_less = D(D < max_distance_pose);
        pose_percentage_sys(k) = numel(D_less)/numel(D) * 100.0;
        average_adds(k) = mean(D);

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

        fprintf("Pose percentage for %s : %f\n", string(header(2*k)), pose_percentage_sys(k));
        fprintf("Pose count for %s : %f\n", string(header(2*k)), numel(D));
        fprintf("Average ADD-S %s : %f\n", string(header(2*k)), average_adds(k));

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