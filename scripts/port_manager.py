#!/usr/bin/env python3
import sys
import json
import os
import fcntl

class PortManager:
    def __init__(self, ports_file="ports.json"):
        self.ports_file = ports_file
        self.ensure_ports_file_exists()

    def ensure_ports_file_exists(self):
        if not os.path.exists(self.ports_file):
            with open(self.ports_file, 'w') as f:
                json.dump({
                    "port_assignments": {},
                    "available_ports": {
                        "start": 5000,
                        "end": 6000
                    }
                }, f)

    def get_next_available_port(self, branch_name):
        with open(self.ports_file, 'r+') as f:
            # File locking to prevent race conditions
            fcntl.flock(f, fcntl.LOCK_EX)
            try:
                data = json.load(f)
                
                # Check if branch already has a port
                if branch_name in data["port_assignments"]:
                    return data["port_assignments"][branch_name]

                # Find next available port
                used_ports = set(data["port_assignments"].values())
                start_port = data["available_ports"]["start"]
                end_port = data["available_ports"]["end"]

                for port in range(start_port, end_port + 1):
                    if port not in used_ports:
                        # Assign port to branch
                        data["port_assignments"][branch_name] = port
                        
                        # Reset file position and write updated data
                        f.seek(0)
                        json.dump(data, f, indent=2)
                        f.truncate()
                        
                        return port
                        
                raise Exception("No available ports")
            finally:
                fcntl.flock(f, fcntl.LOCK_UN)

    def release_port(self, branch_name):
        with open(self.ports_file, 'r+') as f:
            fcntl.flock(f, fcntl.LOCK_EX)
            try:
                data = json.load(f)
                if branch_name in data["port_assignments"]:
                    del data["port_assignments"][branch_name]
                    f.seek(0)
                    json.dump(data, f, indent=2)
                    f.truncate()
            finally:
                fcntl.flock(f, fcntl.LOCK_UN)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: port_manager.py [assign|release] <branch_name>")
        sys.exit(1)

    action = sys.argv[1]
    branch_name = sys.argv[2]
    
    manager = PortManager()
    
    if action == "assign":
        try:
            port = manager.get_next_available_port(branch_name)
            # Output in GitHub Actions environment format
            print(f"APP_PORT={port}")
        except Exception as e:
            print(f"Error: {e}", file=sys.stderr)
            sys.exit(1)
    elif action == "release":
        manager.release_port(branch_name)
    else:
        print(f"Unknown action: {action}", file=sys.stderr)
        sys.exit(1) 