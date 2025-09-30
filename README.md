# Jira Flow Metrics → Excel (Streamlit)

This project is a Streamlit app that fetches Jira issues for a given Sprint, computes flow metrics,
displays them in the UI, and produces an Excel file with pre-filled formulas.

## Features
- Fetch Jira issues matching the sprint and statuses.
- Parse changelogs to determine status transition dates, blocked days, and unassigned time in Peer Review.
- Compute flow metrics in the UI (Cycle Time, Lead Time, PR Time, Flow Efficiency, etc.).
- Produce an Excel file with formulas for the same metrics so users can further manipulate in Excel.

## Files in this project
- `app.py` - Main Streamlit application.
- `requirements.txt` - Python dependencies.
- `Dockerfile` - Build the app in a container (Streamlit server).
- `.dockerignore` - Files ignored by Docker.
- `start.sh` - Helper start script for container (optional).
- `.env.example` - Example environment variables.
- `README.md` - This file.

## Quick local run
1. Create a virtual environment, install dependencies:
   ```bash
   python -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt
   ```
2. Run Streamlit:
   ```bash
   streamlit run main.py
   ```
3. Open http://localhost:8501

## Docker
Build and run with Docker:
```bash
docker build -t jira-flow-metrics:latest .
docker run -p 8501:8501 --env JIRA_EMAIL=you@example.com --env JIRA_API_TOKEN=token jira-flow-metrics:latest
```

## Notes / Security
- Prefer providing API token via environment variable or Streamlit secrets.
- The Dockerfile runs Streamlit server exposed on port 8501.
