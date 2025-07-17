
#!/bin/bash

for gpu in {0..7}; do
  echo "[INFO] Enabling MIG on GPU $gpu..."
  sudo nvidia-smi -i $gpu -mig 1
done

echo "[INFO] Reboot required for MIG changes to take effect."
