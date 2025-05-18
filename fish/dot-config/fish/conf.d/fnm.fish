fnm env --use-on-cd | source

set FNM_COREPACK_ENABLED true

### No need to install packages globally
alias yarn="corepack yarn"
alias yarnpkg="corepack yarnpkg"
alias pnpm="corepack pnpm"
alias pnpx="corepack pnpx"
alias npm="corepack npm"
alias npx="corepack npx"
