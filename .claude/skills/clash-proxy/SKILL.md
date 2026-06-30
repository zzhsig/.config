---
name: clash-proxy
description: Switch the dialer-proxy and proxy group for Kookeey-住宅固定IP in clash.meta config files. Use when the user wants to change the relay node for Kookeey, switch clash proxy, change dialer-proxy, or mentions "kookeey", "中转", "clash proxy", "switch proxy".
user-invocable: true
allowed-tools: Bash, Read, AskUserQuestion
---

# /clash-proxy — Switch Kookeey Dialer Proxy

Interactively select a relay proxy node for `Kookeey-住宅固定IP` in `~/.config/clash.meta/*.yaml` configs. Updates both:
1. The `dialer-proxy` field on the Kookeey proxy entry
2. The first proxy in the `🚀 节点选择` proxy group

## Usage

```
/clash-proxy
```

## How it works

Run the script — it handles everything interactively:

```bash
bash ~/.config/.claude/skills/clash-proxy/switch-proxy.sh
```

The script:
1. Finds all `~/.config/clash.meta/*.yaml` files containing Kookeey
2. Shows current `dialer-proxy` for each config
3. Lets user pick which config to update (or all)
4. Extracts available proxy names (excluding info-only entries)
5. Opens fzf for fuzzy search and selection
6. Updates `dialer-proxy` and `🚀 节点选择` proxy group
7. Saves the config — user must reload in ClashX Meta

## Requirements

- `fzf` — `brew install fzf`
- `python3` with `pyyaml` — `pip3 install pyyaml`
