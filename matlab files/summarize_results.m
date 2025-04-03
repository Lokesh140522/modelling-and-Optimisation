function stats = summarize_results(vals)
    stats.mean = mean(vals);
    stats.std = std(vals);
    stats.best = min(vals);
    stats.worst = max(vals);
end
