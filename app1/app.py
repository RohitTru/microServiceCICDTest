from flask import Flask, request, render_template_string
import redis

app = Flask(__name__)
redis_client = redis.StrictRedis(host='redis', port=6379, decode_responses=True)

form_template = """
<form method="POST" action="/">
    <label for="message">Enter a message:</label>
    <input type="text" name="message" id="message" required>
    <button type="submit">Submit</button>
</form>
<p>{{ feedback }}</p>
"""

@app.route("/", methods=["GET", "POST"])
def index():
    feedback = ""
    if request.method == "POST":
        message = request.form["message"]
        redis_client.set("latest_message", message)
        feedback = f"Message '{message}' saved!"
    return render_template_string(form_template, feedback=feedback)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5004)
