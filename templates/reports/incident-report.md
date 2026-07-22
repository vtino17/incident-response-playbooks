# Incident Report

## Case Information

- Case ID: IR-{YEAR}-{NUMBER}
- Severity: {Critical|High|Medium|Low}
- Status: {Open|Investigation|Contained|Resolved|Closed}
- Date Opened: {YYYY-MM-DD}
- Date Closed: {YYYY-MM-DD}
- Lead Investigator: {NAME}

## Summary

{2-3 sentence executive summary of the incident}

## Timeline

| Timestamp | Event | Source |
|-----------|-------|--------|
| {YYYY-MM-DD HH:MM} | {Initial detection} | {SIEM/EDR/User} |
| {YYYY-MM-DD HH:MM} | {Containment initiated} | {Analyst} |
| {YYYY-MM-DD HH:MM} | {Root cause identified} | {Investigation} |
| {YYYY-MM-DD HH:MM} | {Eradication completed} | {Team} |
| {YYYY-MM-DD HH:MM} | {Recovery completed} | {Team} |

## Indicators of Compromise

### Network Indicators

| Type | Value | Context |
|------|-------|---------|
| IP | {IP_ADDRESS} | {C2/Exfil/Scan} |
| Domain | {DOMAIN} | {Phishing/C2} |
| URL | {URL} | {Payload delivery} |

### Host Indicators

| Type | Value | Path |
|------|-------|------|
| File Hash | {SHA256} | {FILE_PATH} |
| Registry | {KEY} | {VALUE} |
| Process | {NAME} | {PID} |

## Affected Assets

| Hostname | IP Address | Role | Impact |
|----------|------------|------|--------|
| {HOST} | {IP} | {SERVER/WS} | {Full/Partial/None} |

## Root Cause

{Detailed description of how the incident occurred}

## Containment Actions

1. {Action taken}
2. {Action taken}
3. {Action taken}

## Eradication Actions

1. {Action taken}
2. {Action taken}

## Recovery Actions

1. {Action taken}
2. {Action taken}

## Lessons Learned

1. {What went well}
2. {What could be improved}
3. {Action items}
