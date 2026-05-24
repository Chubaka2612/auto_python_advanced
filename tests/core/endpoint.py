import requests

from utils.logger import get_logger


class Endpoint:

    def __init__(self, hostname: str, bearer_token: str):
        self.url = hostname
        self.headers = {
            "Authorization": f"Bearer {bearer_token}",
            "Content-Type": "application/json",
        }
    
        self.log = get_logger(__name__)

    def __truediv__(self, path: str) -> "Endpoint":
        new = object.__new__(Endpoint)
        new.url = f"{self.url}/{path}"
        new.headers = self.headers
        new.log = self.log
        return new

    def get(self, item_id: str = "") -> requests.Response:
        url = f"{self.url}/{item_id}" if item_id else self.url

        self.log.info(f"GET {url}")

        response = requests.get(url, headers=self.headers)

        self.log.debug(f"Response: {response.status_code}")
        return response

    def post(self, body: dict) -> requests.Response:
        self.log.info(f"POST {self.url}")

        response = requests.post(self.url, json=body, headers=self.headers)

        self.log.debug(f"Response: {response.status_code}")
        return response

    def put(self, item_id: str, body: dict) -> requests.Response:
        url = f"{self.url}/{item_id}"

        self.log.info(f"PUT {url}")

        response = requests.put(url, json=body, headers=self.headers)
        self.log.debug(f"Response: {response.status_code}")
        return response

    def delete(self, item_id: str = "", body: dict = None) -> requests.Response:
        url = f"{self.url}/{item_id}" if item_id else self.url

        self.log.info(f"DELETE {url}")

        response = requests.delete(url, json=body, headers=self.headers)
        self.log.debug(f"Response: {response.status_code}")
        return response
