function [best, progress] = run_pso(objfun, D, lb, ub)
    num_particles = 30;
    max_iter = 200;
    w = 0.7; c1 = 1.5; c2 = 1.5;

    pos = repmat(lb, num_particles, 1) + rand(num_particles, D) .* (repmat(ub - lb, num_particles, 1));
    vel = zeros(num_particles, D);
    pbest = pos;
    pbest_val = arrayfun(@(i) objfun(pos(i,:)), 1:num_particles)';
    [~, g_idx] = min(pbest_val);
    gbest = pbest(g_idx,:);
    gbest_val = pbest_val(g_idx);

    progress = zeros(max_iter, 1);

    for iter = 1:max_iter
        for i = 1:num_particles
            vel(i,:) = w * vel(i,:) ...
                     + c1 * rand * (pbest(i,:) - pos(i,:)) ...
                     + c2 * rand * (gbest - pos(i,:));
            pos(i,:) = pos(i,:) + vel(i,:);
            pos(i,:) = max(min(pos(i,:), ub), lb); % bounds

            val = objfun(pos(i,:));
            if val < pbest_val(i)
                pbest(i,:) = pos(i,:);
                pbest_val(i) = val;
            end
        end

        [gbest_val, g_idx] = min(pbest_val);
        gbest = pbest(g_idx,:);
        progress(iter) = gbest_val;
    end

    best = gbest_val;
end
