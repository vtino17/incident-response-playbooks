# Phishing Incident Investigation Playbook

## Initial Analysis

1. Extract email headers from reported phishing message
2. Analyze SPF, DKIM, DMARC authentication results
3. Extract URLs and attachments for sandbox analysis
4. Identify all recipients who received the email

## Indicators

1. Sender IP and domain reputation check
2. URL scan via URLScan.io or VirusTotal
3. Attachment hash analysis
4. Lookalike domain detection

## Remediation

1. Block sender domain at email gateway
2. Remove email from all recipients mailboxes
3. Reset credentials for users who entered credentials
4. Enable MFA for all affected accounts
5. Review mailbox rules for forwarding rules

## Post-Incident

1. Update email gateway filtering rules
2. Add indicators to blocklist
3. Conduct security awareness training for affected users
