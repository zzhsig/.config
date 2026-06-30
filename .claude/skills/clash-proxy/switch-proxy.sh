#!/usr/bin/env bash
# Switch dialer-proxy for Kookeey-住宅固定IP in clash.meta config files.
# Uses fzf for interactive proxy selection with search.
set -euo pipefail

CONFIG_DIR="$HOME/.config/clash.meta"
KOOKEEY_NAMES=("Kookeey-住宅固定IP" "Kookeey")

# Exclude info-only proxy names (not real relay nodes)
EXCLUDE_PATTERN="^(当前网址|剩余流量|套餐到期|流量重置|Kookeey)"

# Find config files containing Kookeey
configs=()
for f in "$CONFIG_DIR"/*.yaml; do
  [[ -f "$f" ]] || continue
  if grep -q -i "kookeey" "$f" 2>/dev/null; then
    configs+=("$f")
  fi
done

if [[ ${#configs[@]} -eq 0 ]]; then
  echo "No clash.meta config files with Kookeey found." >&2
  exit 1
fi

# Let user pick which config file(s) to update
echo "=== Clash Meta configs with Kookeey ==="
for i in "${!configs[@]}"; do
  basename="${configs[$i]##*/}"
  current=$(python3 -c "
import yaml, sys
with open(sys.argv[1]) as f:
    cfg = yaml.safe_load(f)
for p in cfg.get('proxies', []):
    name = p.get('name', '')
    if 'kookeey' in name.lower() or 'Kookeey' in name:
        print(p.get('dialer-proxy', '(none)'))
        break
" "${configs[$i]}" 2>/dev/null || echo "(parse error)")
  echo "  $((i+1)). $basename  [current dialer-proxy: $current]"
done

if [[ ${#configs[@]} -eq 1 ]]; then
  selected_config="${configs[0]}"
  echo ""
  echo "Using: ${selected_config##*/}"
else
  echo ""
  read -rp "Select config (number, or 'a' for all): " choice
  if [[ "$choice" == "a" ]]; then
    selected_config="ALL"
  elif [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#configs[@]} )); then
    selected_config="${configs[$((choice-1))]}"
  else
    echo "Invalid choice." >&2
    exit 1
  fi
fi

# Extract proxy names from first selected config for fzf
ref_config="${selected_config}"
[[ "$ref_config" == "ALL" ]] && ref_config="${configs[0]}"

proxy_names=$(python3 -c "
import yaml, sys, re
with open(sys.argv[1]) as f:
    cfg = yaml.safe_load(f)
exclude = re.compile(r'''$EXCLUDE_PATTERN''')
for p in cfg.get('proxies', []):
    name = p.get('name', '')
    if name and not exclude.match(name):
        print(name)
" "$ref_config")

if [[ -z "$proxy_names" ]]; then
  echo "No selectable proxies found in config." >&2
  exit 1
fi

# Use fzf for selection
if ! command -v fzf &>/dev/null; then
  echo "fzf is required. Install: brew install fzf" >&2
  exit 1
fi

selected=$(echo "$proxy_names" | fzf --prompt="Select dialer-proxy for Kookeey > " --height=40% --reverse --border --header="Type to search proxies")

if [[ -z "$selected" ]]; then
  echo "No proxy selected." >&2
  exit 1
fi

echo ""
echo "Selected: $selected"

# Apply the change
apply_change() {
  local config_file="$1"
  local proxy_name="$2"
  python3 -c "
import yaml, sys

config_path = sys.argv[1]
new_dialer = sys.argv[2]
kookeey_names = ['Kookeey-住宅固定IP', 'Kookeey']
select_group = '🚀 节点选择'

with open(config_path, 'r') as f:
    cfg = yaml.safe_load(f)

changed = False

# Update dialer-proxy
for p in cfg.get('proxies', []):
    if p.get('name') in kookeey_names:
        old = p.get('dialer-proxy', '(none)')
        p['dialer-proxy'] = new_dialer
        print(f'  dialer-proxy: {old} -> {new_dialer}')
        changed = True
        break

# Update 🚀 节点选择 first proxy
for g in cfg.get('proxy-groups', []):
    if g.get('name') == select_group:
        proxies = g.get('proxies', [])
        # Replace the first non-Kookeey, non-DIRECT entry
        for i, pn in enumerate(proxies):
            if pn not in kookeey_names and pn != 'DIRECT':
                old = pn
                proxies[i] = new_dialer
                print(f'  {select_group} first proxy: {old} -> {new_dialer}')
                changed = True
                break
        break

if changed:
    with open(config_path, 'w') as f:
        yaml.dump(cfg, f, allow_unicode=True, default_flow_style=False, sort_keys=False, width=1000)
    print(f'  Saved.')
else:
    print(f'  No changes needed.')
" "$config_file" "$proxy_name"
}

if [[ "$selected_config" == "ALL" ]]; then
  for cfg in "${configs[@]}"; do
    echo ""
    echo "--- ${cfg##*/} ---"
    apply_change "$cfg" "$selected"
  done
else
  echo ""
  echo "--- ${selected_config##*/} ---"
  apply_change "$selected_config" "$selected"
fi

echo ""
echo "Done. Reload config in ClashX Meta to apply."
