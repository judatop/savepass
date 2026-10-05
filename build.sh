#!/bin/bash
set -euo pipefail

ENV="${1:-}"

if [ "$ENV" != "dev" ] && [ "$ENV" != "prod" ]; then
  echo "Usage: ./build.sh <dev|prod>"
  exit 1
fi

if [ ! -f ".env.$ENV" ]; then
  echo "ERROR: .env.$ENV not found"
  exit 1
fi

echo "Setting environment to $ENV"
cp ".env.$ENV" ".env"

# build_runner only caches on .dart inputs, so without a clean it keeps the
# previous flavor's secrets in env.g.dart.
echo "Cleaning build_runner..."
dart run build_runner clean

echo "Generating env.g.dart..."
dart run build_runner build --delete-conflicting-outputs

echo "Verifying generated secrets match .env.$ENV..."
python3 - "$ENV" <<'PY'
import re, sys

flavor = sys.argv[1]
generated = 'lib/core/env/env.g.dart'

expected = None
for line in open(f'.env.{flavor}'):
    if line.startswith('SUPABASE_URL='):
        expected = line.split('=', 1)[1].strip()

src = open(generated).read()

def ints(kind):
    m = re.search(r'_envied%ssupabaseURL\s*=\s*<int>\[(.*?)\];' % kind, src, re.S)
    return [int(x) for x in re.findall(r'-?\d+', m.group(1))] if m else None

key, data = ints('key'), ints('data')
if not expected or not key or not data:
    sys.exit(f'ERROR: could not verify {generated} against .env.{flavor}')

actual = ''.join(chr(a ^ b) for a, b in zip(data, key))
if actual != expected:
    sys.exit(
        f'ERROR: {generated} holds the wrong secrets.\n'
        f'  expected ({flavor}): {expected}\n'
        f'  generated:           {actual}'
    )
PY

# Consumed by the flavor guards in Gradle and Xcode.
md5 -q ".env.$ENV" > .envied.lock 2>/dev/null || md5sum ".env.$ENV" | cut -d' ' -f1 > .envied.lock
echo "$ENV" >> .envied.lock

echo "Environment $ENV ready"
