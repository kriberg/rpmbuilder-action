import os
import subprocess
from typing import List, Optional
from actions_toolkit import core


def exec(cmd: List[str]) -> Optional[str]:
    core.info(f"Running {cmd} in {os.getcwd()}, contents {list(os.scandir())}")
    proc = subprocess.run(cmd)
    core.info(str(proc.stdout))
    if not proc.returncode == 0:
        core.set_failed(str(proc.stderr))
    return str(proc.stdout)
