# Incident Response Playbooks

Enterprise-grade incident response framework with playbooks, forensics collection scripts, SIEM query libraries, evidence management templates, and communication templates for security operations teams.

## Structure

```
incident-response-playbooks/
  playbooks/            Incident-specific response procedures
  scripts/windows/      Windows forensics acquisition
  scripts/linux/        Linux forensics acquisition
  scripts/network/      Network evidence collection
  forensics/            Analysis scripts and decoders
  queries/splunk/       Splunk SPL detection queries
  queries/elastic/      Elasticsearch EQL/KQL queries
  queries/wazuh/        Wazuh decoder and rule XML
  templates/reports/    Incident report templates
  templates/communication/ Stakeholder notification templates
  evidence/             Evidence handling procedures
  docs/                 Operational documentation
```

## Quick Start

```bash
git clone https://github.com/vtino17/incident-response-playbooks.git
cd incident-response-playbooks

# For a ransomware incident
cat playbooks/ransomware.md

# Collect Windows forensics
sudo python scripts/windows/collect_evidence.ps1

# Query SIEM for IOCs
cat queries/splunk/ioc_hunting.spl
```

## Playbooks

- Ransomware response
- Phishing investigation
- Data breach containment
- DDoS mitigation
- Insider threat
- Malware outbreak
- Unauthorized access
- Business email compromise

## License

MIT
