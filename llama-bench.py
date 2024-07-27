import requests
import time
import argparse
from statistics import mean
from tabulate import tabulate

def run_benchmark(url, prompt, n_predict, num_runs):
    results = []
    for _ in range(num_runs):
        start_time = time.time()
        response = requests.post(
            url,
            headers={"Content-Type": "application/json"},
            json={"prompt": prompt, "n_predict": n_predict}
        )
        end_time = time.time()
        
        if response.status_code == 200:
            data = response.json()
            tokens_predicted = data.get('tokens_predicted', 0)
            elapsed_time = end_time - start_time
            tokens_per_second = tokens_predicted / elapsed_time if elapsed_time > 0 else 0
            results.append({
                'elapsed_time': elapsed_time,
                'tokens_predicted': tokens_predicted,
                'tokens_per_second': tokens_per_second
            })
        else:
            print(f"Request failed with status code: {response.status_code}")
    
    return results

def calculate_stats(results):
    stats = {}
    for key in ['elapsed_time', 'tokens_predicted', 'tokens_per_second']:
        values = [result[key] for result in results]
        stats[key] = {
            'min': min(values),
            'max': max(values),
            'avg': mean(values)
        }
    return stats

def print_results(stats):
    table_data = []
    for key, value in stats.items():
        table_data.append([
            key.replace('_', ' ').title(),
            f"{value['min']:.2f}",
            f"{value['max']:.2f}",
            f"{value['avg']:.2f}"
        ])
    
    headers = ["Metric", "Min", "Max", "Avg"]
    print(tabulate(table_data, headers=headers, tablefmt="grid"))

def main():
    parser = argparse.ArgumentParser(description="API Benchmark Script")
    parser.add_argument("--url", default="http://localhost:8000/completion", help="API endpoint URL")
    parser.add_argument("--prompt", default="Building a website can be done in 10 simple steps:", help="Prompt for the API")
    parser.add_argument("--n_predict", type=int, default=512, help="Number of tokens to predict")
    parser.add_argument("--num_runs", type=int, default=16, help="Number of benchmark runs")
    
    args = parser.parse_args()
    
    results = run_benchmark(args.url, args.prompt, args.n_predict, args.num_runs)
    stats = calculate_stats(results)
    print_results(stats)

if __name__ == "__main__":
    main()