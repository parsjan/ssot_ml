#!/bin/bash

echo "[INFO] Extracting DCGM Exporter..."
tar -xzf ./dcgm-exporter/dcgm-exporter.tar.gz -C /opt/
chmod +x /opt/dcgm-exporter/dcgm-exporter

# ---------------------
# Verification
# ---------------------
echo "[INFO] Verifying DCGM Exporter installation..."

# 1. Check if the binary exists and is executable
if [[ -x /opt/dcgm-exporter/dcgm-exporter ]]; then
    echo "[✔] DCGM Exporter binary is present and executable."
else
    echo "[✘] DCGM Exporter binary missing or not executable."
    exit 1
fi

# 2. Run the exporter in background for test
echo "[INFO] Starting DCGM Exporter temporarily for test..."
/opt/dcgm-exporter/dcgm-exporter &

EXPORTER_PID=$!
sleep 3

# 3. Check if it's listening on port 9400 (default Prometheus port)
if curl -s http://localhost:9400/metrics | grep -q "DCGM"; then
    echo "[✔] DCGM Exporter is running and exposing metrics."
else
    echo "[✘] DCGM Exporter failed to expose metrics on port 9400."
    kill "$EXPORTER_PID"
    exit 1
fi

# Stop the temporary instance
kill "$EXPORTER_PID"
echo "[INFO] Temporary DCGM Exporter stopped."

echo "[SUCCESS] DCGM Exporter installed and verified successfully."
echo "[INFO] To run it manually: /opt/dcgm-exporter/dcgm-exporter"
