import subprocess

def run(command: list) -> str:
    return subprocess.run(command, stdout=subprocess.PIPE).stdout.decode("utf-8").strip()
