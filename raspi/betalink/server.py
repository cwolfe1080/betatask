import socket, threading, json, sys

clients = {}

def handle_client(conn, addr):
    user = "Unknown"
    try:
        while True:
            raw = conn.recv(1024).decode()
            if not raw: break
            data = json.loads(raw)
            action = data.get("action")

            if action == "register":
                user = data.get("user")
                clients[user] = conn
                print(f"\n[+] {user} joined from {addr}")
            elif action == "scan":
                conn.send(json.dumps({"online": list(clients.keys())}).encode())
            elif action == "message":
                target = data.get("to")
                if target in clients:
                    payload = json.dumps({"from": user, "msg": data.get("msg")})
                    clients[target].send(payload.encode())
            print(f"Server (type 'exit' to stop) > ", end="", flush=True)
    except: pass
    finally:
        if user in clients: del clients[user]
        conn.close()

def run_server():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind(('0.0.0.0', 5000))
    s.listen(10)
    print("--- BetaLink Server Online ---")
    while True:
        try:
            c, a = s.accept()
            threading.Thread(target=handle_client, args=(c, a), daemon=True).start()
        except: break

# Start network in background
threading.Thread(target=run_server, daemon=True).start()

# Main loop for Server Admin
while True:
    cmd = input("Server (type 'exit' to stop) > ").strip().lower()
    if cmd == "exit":
        print("Shutting down BetaLink Server...")
        sys.exit(0)
