from pathlib import Path
from subprocess import run

'''
Sample script for how to do font manipulation mainly on Arch Linux
Always so hard to forget relevant commands so this is more of a
documentation that a script that can be run right away
'''

def cmd_stdout_to_str(cmd: list[str]) -> str:
    return run(cmd, capture_output=True, text=True).stdout


def get_current_fonts() -> tuple[str, str, str]:
    sans = cmd_stdout_to_str(['fc-match', 'sans',])
    serif = cmd_stdout_to_str(['fc-match', 'serif',])
    monospace = cmd_stdout_to_str(['fc-match', 'monospace',])
    return sans, serif, monospace

def get_current_user_config() -> str:
    config_path: Path = Path.home() / '.config' / 'fontconfig' / 'fonts.config'
    if not config_path.is_file():
        return f"ERROR: file {config_path} does not exist. On Arch Linux you need to use this file."
    with open(config_path, 'r') as fr:
        file_contents = fr.read()
    return file_contents


def print_state():
    sans, serif, monospace = get_current_fonts()
    print(
        f"CURRENTLY IN USE:\n\n"
        f"Sans: {sans}\nSerif: {serif}\nMonospace: {monospace}\n\n"
        f"CURRENT USER LEVEL CONFIG:\n\n"
        f"{get_current_user_config()}"
    )

def refresh_fonts():
    run(['fc-cache', '-f', '-v'])


if __name__ == '__main__':
    refresh_fonts()
    print('\n\n')
    print_state()
