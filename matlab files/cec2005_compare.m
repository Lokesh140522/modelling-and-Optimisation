clc; clear;

% Benchmark functions to evaluate
functions = [8, 11, 21];  % Function numbers from CEC'2005
dims = [2, 10];
runs = 15;

results = struct();

for fi = 1:length(functions)
    func_num = functions(fi);
    for di = 1:length(dims)
        D = dims(di);
        fprintf('Running Function %d in %dD...\n', func_num, D);

        % Define bounds based on function characteristics
        switch func_num
            case 8
                lb = -32 * ones(1, D);
                ub =  32 * ones(1, D);
            case 11
                lb = -0.5 * ones(1, D);
                ub =  0.5 * ones(1, D);
            otherwise
                lb = -5 * ones(1, D);
                ub =  5 * ones(1, D);
        end

        % Preallocate storage
        ga_vals = zeros(runs, 1);
        pso_vals = zeros(runs, 1);
        sa_vals = zeros(runs, 1);

        for r = 1:runs
            global initial_flag
            initial_flag = 0;

            [ga_vals(r), ~] = run_ga(@(x) benchmark_func(x, func_num), D, lb, ub);
            [pso_vals(r), ~] = run_pso(@(x) benchmark_func(x, func_num), D, lb, ub);
            [sa_vals(r), ~] = run_sa(@(x) benchmark_func(x, func_num), D, lb, ub);
        end

        % Store summarized results
        results(fi).func_num = func_num;
        results(fi).dimension(di).D = D;
        results(fi).dimension(di).GA = summarize_results(ga_vals);
        results(fi).dimension(di).PSO = summarize_results(pso_vals);
        results(fi).dimension(di).SA = summarize_results(sa_vals);
    end
end

% Display summary
disp('==================================');
disp('Summary of Results:');
for fi = 1:length(results)
    func = results(fi).func_num;
    for di = 1:length(results(fi).dimension)
        D = results(fi).dimension(di).D;
        fprintf('\nFunction %d - Dimension %d\n', func, D);

        algs = {'GA', 'PSO', 'SA'};
        for a = 1:length(algs)
            alg = algs{a};
            stats = results(fi).dimension(di).(alg);
            fprintf('%s: Best = %.4f, Worst = %.4f, Mean = %.4f, Std = %.4f\n', ...
                alg, stats.best, stats.worst, stats.mean, stats.std);
        end
    end
end
