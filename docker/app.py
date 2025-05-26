from flask import Flask

app = Flask(__name__)

@app.route("/wish")
def pleaseWish():
    return "Hello, Welcome to First Devops Project"

if __name__ == "__main__":
    app.run(host = "0.0.0.0", port="5000")

# 0.0.0.0 ==> all Traffic
# The default port no is always 5000
