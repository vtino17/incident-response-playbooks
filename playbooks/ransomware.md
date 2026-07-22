# Ransomware Incident Response Playbook

## Triage

1. Identify affected systems from EDR alerts
2. Determine ransomware variant from file extensions and ransom note
3. Assess encryption scope: local vs network-wide
4. Check if backup infrastructure is compromised
5. Escalate to incident response team

## Containment

1. Isolate affected systems from network
   - Disconnect network cables or disable switch ports
   - Block C2 infrastructure at firewall
2. Disable Active Directory domain trust relationships if spread detected
3. Block ransomware IOCs at perimeter firewall
4. Preserve memory and disk evidence before remediation

## Eradication

1. Identify initial access vector from logs
2. Remove persistence mechanisms
3. Reset all domain account credentials
4. Rotate service account secrets
5. Patch vulnerability used for initial access

## Recovery

1. Restore from verified clean backups
2. Validate backup integrity before mass recovery
3. Prioritize recovery order: domain controllers first, then critical servers
4. Monitor for re-infection after restoration

## Post-Incident

1. Conduct root cause analysis
2. Update detection rules with new IOCs
3. Improve backup validation procedures
4. Conduct tabletop exercise based on lessons learned
