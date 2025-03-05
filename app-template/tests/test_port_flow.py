import pytest
import os

def test_port_assignment():
    """Test that port is assigned correctly in development"""
    port = os.getenv('APP_PORT')
    assert port is not None, "Port should be assigned"
    port_num = int(port)
    assert 5000 <= port_num <= 5999, "Development port should be in range 5000-5999"

def test_environment_setup():
    """Test that environment is set up correctly"""
    env = os.getenv('ENVIRONMENT')
    assert env is not None, "Environment should be set"
    assert env in ['development', 'staging', 'production'], "Environment should be valid"

def test_virtual_host():
    """Test that virtual host is configured correctly"""
    host = os.getenv('VIRTUAL_HOST')
    assert host is not None, "Virtual host should be set"
    assert host.endswith('.emerginary.com'), "Virtual host should be under emerginary.com domain" 