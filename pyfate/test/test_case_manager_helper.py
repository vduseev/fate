import os
import random

from pathlib import Path


def generate_random_case_name():
    """Generates random string for test case names.
    """
    name_length = 6
    name = "".join(
        random.choices(string.ascii_uppercase + string.digits), k=name_length
    )
    return name


def list_files_in_dir(path):
    """Lists files ind dirs in a given directory
    """
    print(f"Files in directory {path}:")
    for f in os.listdir(path):
        print(f)
