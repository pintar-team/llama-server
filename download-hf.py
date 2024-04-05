import argparse
import os
from huggingface_hub import snapshot_download

def download_model(model_id, local_dir):
    if not os.path.exists(local_dir):
        os.makedirs(local_dir)
    snapshot_download(repo_id=model_id, local_dir=local_dir,
                      local_dir_use_symlinks=False, revision="main")

def main():
    parser = argparse.ArgumentParser(description="Download a model from Hugging Face Hub")
    parser.add_argument("--model", type=str, required=True, help="ID of the model to download")
    parser.add_argument("--localdir", type=str, help="Local directory to store the model")
    args = parser.parse_args()

    local_dir = args.localdir if args.localdir else f'hf-download/{args.model}'
    download_model(args.model, local_dir)

if __name__ == "__main__":
    main()
