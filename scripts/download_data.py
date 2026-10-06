"""Download the public Credit Card Fraud dataset (ULB / Kaggle) into data/.

The file is ~100 MB, so it is not committed to the repository.
Original source: https://www.kaggle.com/datasets/mlg-ulb/creditcardfraud
"""
from pathlib import Path
import urllib.request

URL = ("https://raw.githubusercontent.com/nsethi31/"
       "Kaggle-Data-Credit-Card-Fraud-Detection/master/creditcard.csv")
out = Path(__file__).resolve().parents[1] / "data" / "creditcard.csv"
out.parent.mkdir(exist_ok=True)
if out.exists():
    print(f"Already downloaded: {out}")
else:
    print("Downloading creditcard.csv (~100 MB)...")
    urllib.request.urlretrieve(URL, out)
    print(f"Saved to {out}")
