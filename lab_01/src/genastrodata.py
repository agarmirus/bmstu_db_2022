import requests

response = requests.get("https://api.astrocats.space/")

print(response.content)
