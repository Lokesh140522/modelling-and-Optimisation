function [best, progress] = run_ga(objfun, D, lb, ub)
    pop_size = 50;
    max_gen = 200;
    mutation_rate = 0.1;

    % Initialize population
    pop = repmat(lb, pop_size, 1) + rand(pop_size, D) .* repmat(ub - lb, pop_size, 1);
    fitness = arrayfun(@(i) objfun(pop(i,:)), 1:pop_size)';

    progress = zeros(max_gen, 1); % Convergence tracker

    for gen = 1:max_gen
        % Tournament selection
        idx = randi(pop_size, pop_size, 2);
        parents = pop(sub2ind(size(pop), idx(:,1), ones(pop_size,1))) < ...
                  pop(sub2ind(size(pop), idx(:,2), ones(pop_size,1)));
        winners = idx(sub2ind(size(idx), (1:pop_size)', parents + 1));
        mating_pool = pop(winners,:);

        % Crossover
        offspring = mating_pool;
        for i = 1:2:pop_size-1
            alpha = rand;
            offspring(i,:) = alpha * mating_pool(i,:) + (1-alpha) * mating_pool(i+1,:);
            offspring(i+1,:) = alpha * mating_pool(i+1,:) + (1-alpha) * mating_pool(i,:);
        end

        % Mutation
        mutations = rand(pop_size, D) < mutation_rate;
        offspring = offspring + mutations .* randn(pop_size, D) .* 0.1;

        % Enforce bounds
        offspring = max(min(offspring, ub), lb);

        % Evaluate offspring
        fitness_off = arrayfun(@(i) objfun(offspring(i,:)), 1:pop_size)';

        % Replace population
        pop = offspring;
        fitness = fitness_off;

        % Track best fitness in generation
        progress(gen) = min(fitness);
    end

    best = min(fitness);
end
