function [best, progress] = run_sa(objfun, D, lb, ub)
    max_iter = 200;
    T = 100;
    alpha = 0.95;

    x = lb + (ub - lb) .* rand(1,D);
    fx = objfun(x);
    progress = zeros(max_iter, 1);

    for k = 1:max_iter
        x_new = x + 0.1 * randn(1,D);
        x_new = max(min(x_new, ub), lb);
        fx_new = objfun(x_new);

        if fx_new < fx || rand < exp(-(fx_new - fx)/T)
            x = x_new;
            fx = fx_new;
        end

        progress(k) = fx;
        T = T * alpha;
    end

    best = fx;
