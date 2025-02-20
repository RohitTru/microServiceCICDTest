from flask import Flask
import redis

app = Flask(__name__)
redis_client = redis.StrictRedis(host='redis', port=6379, decode_responses=True)

@app.route('/health', methods=['GET'])
def health():
    return "OK", 200

@app.route("/")
def show_message():
    message = redis_client.get("latest_message")
    if message:
        return f"Last message submitted: {message}"
    else:
        return "No messages submitted yet!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5005)
