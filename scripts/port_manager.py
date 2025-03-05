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
                    "environments": {
                        "development": {
                            "port_range": {"start": 5000, "end": 5999},
                            "assignments": {}
                        },
                        "staging": {
                            "port_range": {"start": 6000, "end": 6999},
                            "assignments": {}
                        },
                        "production": {
                            "port_range": {"start": 7000, "end": 7999},
                            "assignments": {}
                        }
                    }
                }, f, indent=2)

    def get_environment_for_branch(self, branch_name):
        if branch_name.endswith("/master"):
            return "production"
        elif branch_name.endswith("/staging"):
            return "staging"
        else:
            return "development"

    def get_next_available_port(self, branch_name, target_env=None):
        with open(self.ports_file, 'r+') as f:
            # Lock the file for atomic read/write
            fcntl.flock(f, fcntl.LOCK_EX)
            try:
                data = json.load(f)
                
                # Determine environment
                env = target_env or self.get_environment_for_branch(branch_name)
                env_data = data["environments"][env]
                
                # Get port range for environment
                start_port = env_data["port_range"]["start"]
                end_port = env_data["port_range"]["end"]
                
                # Get used ports
                used_ports = set(env_data["assignments"].values())
                
                # Find next available port
                for port in range(start_port, end_port + 1):
                    if port not in used_ports:
                        # Assign port
                        env_data["assignments"][branch_name] = port
                        
                        # Write back to file
                        f.seek(0)
                        json.dump(data, f, indent=2)
                        f.truncate()
                        
                        return port
                
                raise Exception(f"No available ports in range {start_port}-{end_port}")
            finally:
                fcntl.flock(f, fcntl.LOCK_UN)

    def release_port(self, branch_name, environment=None):
        with open(self.ports_file, 'r+') as f:
            # Lock the file for atomic read/write
            fcntl.flock(f, fcntl.LOCK_EX)
            try:
                data = json.load(f)
                
                # Determine environment
                env = environment or self.get_environment_for_branch(branch_name)
                
                # Remove port assignment if it exists
                if branch_name in data["environments"][env]["assignments"]:
                    del data["environments"][env]["assignments"][branch_name]
                    
                    # Write back to file
                    f.seek(0)
                    json.dump(data, f, indent=2)
                    f.truncate()
            finally:
                fcntl.flock(f, fcntl.LOCK_UN)

    def migrate_port(self, branch_name, from_env, to_env):
        """
        Migrate a branch's port assignment from one environment to another.
        
        Args:
            branch_name (str): Name of the branch to migrate
            from_env (str): Source environment (e.g., "development")
            to_env (str): Target environment (e.g., "staging")
            
        Returns:
            int: The new port number assigned in the target environment
        """
        with open(self.ports_file, 'r+') as f:
            # Lock the file for atomic read/write
            fcntl.flock(f, fcntl.LOCK_EX)
            try:
                data = json.load(f)
                
                # Get target environment port range
                target_env_data = data["environments"][to_env]
                start_port = target_env_data["port_range"]["start"]
                end_port = target_env_data["port_range"]["end"]
                
                # Get used ports in target environment
                used_ports = set(target_env_data["assignments"].values())
                
                # Find next available port in target environment
                for port in range(start_port, end_port + 1):
                    if port not in used_ports:
                        # Assign new port in target environment
                        target_env_data["assignments"][branch_name] = port
                        
                        # Write back to file
                        f.seek(0)
                        json.dump(data, f, indent=2)
                        f.truncate()
                        
                        return port
                
                raise Exception(f"No available ports in target environment range {start_port}-{end_port}")
            finally:
                fcntl.flock(f, fcntl.LOCK_UN)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: port_manager.py [assign|release|migrate] <branch_name> [from_env] [to_env]")
        sys.exit(1)

    action = sys.argv[1]
    branch_name = sys.argv[2]
    
    manager = PortManager()
    
    try:
        if action == "assign":
            target_env = sys.argv[3] if len(sys.argv) > 3 else None
            port = manager.get_next_available_port(branch_name, target_env)
            # Output in GitHub Actions environment format
            print(f"APP_PORT={port}")
        elif action == "release":
            environment = sys.argv[3] if len(sys.argv) > 3 else None
            manager.release_port(branch_name, environment)
        elif action == "migrate":
            if len(sys.argv) < 5:
                print("Error: migrate requires from_env and to_env parameters")
                sys.exit(1)
            from_env = sys.argv[3]
            to_env = sys.argv[4]
            new_port = manager.migrate_port(branch_name, from_env, to_env)
            print(f"APP_PORT={new_port}")
        else:
            print(f"Unknown action: {action}", file=sys.stderr)
            sys.exit(1)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1) 