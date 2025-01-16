# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "python-dotenv",
#     "requests",
# ]
# ///

# RUN with : uv run nordvpn_wireguard.py

import os

import requests
from dotenv import load_dotenv

load_dotenv()


def get_key(token):
    if not token:
        print("Error: Token is empty. Please provide a valid token.")
        return

    headers = {
        'Authorization': f'token:{token}'
    }

    try:
        response = requests.get("https://api.nordvpn.com/v1/users/services/credentials", headers=headers)
        response.raise_for_status()  # Check if the request was successful
        data = response.json()
        key = data.get('nordlynx_private_key')

        if key:
            print(f"Key: {key}")
        else:
            print("Key not found in the response")

    except Exception as e:
        print(f"Error fetching key: {e}")

if __name__ == "__main__":
    token = os.getenv("NORDVPN_ACCESS_TOKEN")
    get_key(token)
