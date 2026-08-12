#!/usr/bin/env bash
set -euo pipefail

repo="/Users/franckdelage/code/caveman-code"
branch="custom/integrations"

cd "$repo"
if [[ -n "$(git status --porcelain)" ]]; then
	echo "Refusing update: working tree is not clean." >&2
	exit 1
fi

git fetch upstream
git switch "$branch"
git rebase upstream/main
npm ci
npm run build
git restore packages/ai/src/models.generated.ts
npm test --workspace @juliusbrussee/caveman-agent -- src/__tests__/memory-cavemem.test.ts
npm test --workspace @juliusbrussee/caveman-code -- test/memory-factory.test.ts test/rtk.test.ts
(cd packages/coding-agent && npm link)

caveman --version
node --input-type=module -e "import('$repo/packages/coding-agent/dist/core/memory-factory.js').then(async m=>{m.resetMemoryProviderCache();const p=await m.resolveMemoryProvider({cwd:'$repo'});console.log('memory provider:',p.id,'hub:',Boolean(p.hub));process.exit(p.id==='cavemem'&&p.hub?0:1)})"
node --input-type=module -e "import('$repo/packages/coding-agent/dist/core/rtk.js').then(async m=>{const status=await m.getRtkStatus();const rewritten=await m.rewriteCommand('git status');console.log('rtk:',status.version,'rewrite:',rewritten);process.exit(status.available&&rewritten!=='git status'?0:1)})"

echo "Fork updated and linked. Review rebased commits, then push with:"
echo "  git -C $repo push --force-with-lease origin $branch"
