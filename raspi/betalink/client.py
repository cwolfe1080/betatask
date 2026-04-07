import socket, threading, json, sys

def listen(s):
    while True:
        try:
            raw = s.recv(1024).decode()
            if not raw: break
            data = json.loads(raw)
            if "online" in data:
                print(f"\n[SCAN] Online: {', '.join(data['online'])}")
            else:
                print(f"\n[{data['from']}]: {data['msg']}")
            print("BetaLink > ", end="", flush=True)
        except:
            print("\n[!] Connection lost.")
            break

def start():
    default_ip = "172.18.0.10"
    print("--- BetaLink Client ---")
    srv = input(f"Server IP [{default_ip}]: ").strip() or default_ip
    
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.settimeout(3)
    try:
        s.connect((srv, 5000))
        s.settimeout(None)
    except Exception as e:
        print(f"[!] Fail: {e}"); return

    name = input("Username: ").strip()
    s.send(json.dumps({"action": "register", "user": name}).encode())
    threading.Thread(target=listen, args=(s,), daemon=True).start()

    print("Type: 'scan', 'msg user:text', or 'exit'")
    while True:
        try:
            cmd = input("BetaLink > ").strip()
            if cmd == "exit": break
            if cmd == "scan":
                s.send(json.dumps({"action": "scan"}).encode())
            elif cmd.startswith("msg "):
                _, content = cmd.split(" ", 1)
                user, msg = content.split(":", 1)
                s.send(json.dumps({"action": "message", "to": user, "msg": msg}).encode())
        except: print("Invalid command. Example: msg Dave:Hello")
    s.close()

if __name__ == "__main__": start()
