# Data Breach Response Playbook

## Detection

1. Identify data access pattern anomalies from logs
2. Determine data types involved (PII, financial, credentials)
3. Assess number of affected records
4. Check for public disclosure or dark web posting
5. Engage legal team immediately

## Containment

1. Revoke compromised access credentials
2. Isolate affected systems
3. Block exfiltration paths at firewall
4. Enable enhanced logging on all entry points
5. Preserve forensic evidence before remediation

## Notification

1. Notify DPO and compliance team
2. Determine regulatory notification requirements (GDPR 72h, CCPA, etc.)
3. Draft preliminary notification for regulators
4. Prepare affected user communication
5. Establish media response if public disclosure expected

## Investigation

1. Determine entry vector and time of initial access
2. Identify data accessed and exfiltrated
3. Map lateral movement within environment
4. Identify persistence mechanisms
5. Document full timeline

## Remediation

1. Patch or mitigate entry vector
2. Remove persistence mechanisms
3. Rotate all credentials in affected scope
4. Enhance monitoring rules
5. Conduct post-incident review
