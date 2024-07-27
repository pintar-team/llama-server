#!/bin/bash

# Default values
URL="http://localhost:8000/completion"
PROMPT="Building a website can be done in 10 simple steps:"
N_PREDICT=512
NUM_RUNS=4

# Function to print usage
print_usage() {
    echo "Usage: $0 [-u URL] [-p PROMPT] [-n N_PREDICT] [-r NUM_RUNS]"
    echo "  -u URL        API endpoint URL (default: $URL)"
    echo "  -p PROMPT     Prompt for the API (default: $PROMPT)"
    echo "  -n N_PREDICT  Number of tokens to predict (default: $N_PREDICT)"
    echo "  -r NUM_RUNS   Number of benchmark runs (default: $NUM_RUNS)"
}

# Parse command line arguments
while getopts "u:p:n:r:h" opt; do
    case $opt in
        u) URL="$OPTARG" ;;
        p) PROMPT="$OPTARG" ;;
        n) N_PREDICT="$OPTARG" ;;
        r) NUM_RUNS="$OPTARG" ;;
        h) print_usage; exit 0 ;;
        \?) echo "Invalid option -$OPTARG" >&2; print_usage; exit 1 ;;
    esac
done

# Function to extract tokens_predicted from JSON response
extract_tokens_predicted() {
    echo "$1" | grep -o '"tokens_predicted":[0-9]*' | cut -d':' -f2
}

# Function to run a single benchmark
run_benchmark() {
    start_time=$(date +%s.%N)
    response=$(curl -s -X POST "$URL" \
        -H "Content-Type: application/json" \
        -d "{\"prompt\": \"$PROMPT\", \"n_predict\": $N_PREDICT}")
    end_time=$(date +%s.%N)

    tokens_predicted=$(extract_tokens_predicted "$response")
    elapsed_time=$(echo "$end_time - $start_time" | bc -l)
    tokens_per_second=$(echo "scale=2; $tokens_predicted / $elapsed_time" | bc -l)

    echo "$elapsed_time $tokens_predicted $tokens_per_second"
}

# Run benchmarks and collect results
results=()
for i in $(seq 1 $NUM_RUNS); do
    result=$(run_benchmark)
    results+=("$result")
    echo "Run $i completed"
done

# Calculate statistics
calculate_stats() {
    local -n arr=$1
    local field=$2
    local min max sum
    min=$(echo "${arr[0]}" | awk "{print \$$field}")
    max=$min
    sum=0

    for item in "${arr[@]}"; do
        value=$(echo "$item" | awk "{print \$$field}")
        sum=$(echo "$sum + $value" | bc -l)
        if (( $(echo "$value < $min" | bc -l) )); then min=$value; fi
        if (( $(echo "$value > $max" | bc -l) )); then max=$value; fi
    done

    avg=$(echo "scale=2; $sum / ${#arr[@]}" | bc -l)
    echo "$min $max $avg"
}

# Function to format number according to locale
format_number() {
    printf "%'.2f" "$1" | sed 's/\./,/g'
}

# Print results
print_results() {
    local title=$1
    local stats=$2
    printf "%-25s %-10s %-10s %-10s\n" "$title" "Min" "Max" "Avg"
    echo "$stats" | while read -r min max avg; do
        printf "%-25s %-10s %-10s %-10s\n" "$title" "$(format_number "$min")" "$(format_number "$max")" "$(format_number "$avg")"
    done
}

echo "Benchmark Results:"
echo "------------------"
print_results "Elapsed Time (s)" "$(calculate_stats results 1)"
print_results "Tokens Predicted" "$(calculate_stats results 2)"
print_results "Tokens per Second" "$(calculate_stats results 3)"
