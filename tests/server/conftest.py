# ponytail: puts the repo root on sys.path so `import server.*` works; replace with a server/pyproject.toml once the server is a package.
import sys, pathlib

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[2]))
