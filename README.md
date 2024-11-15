# Helm Chart Integration for Cilium Network Policies

This repository contains files designed to be included in a Helm chart to enable application-specific network policy capabilities. Integrating these files ensures that network policies are automatically deployed or removed alongside the application, minimizing the risk of oversight.

## Structure and Usage

- `templates/` Directory: Add the provided files to the templates folder of your Helm chart.
- `values.yaml`: Refer to the examples provided in values.yaml to understand how to configure the chart for deploying network policies alongside your application.

## Features and Limitations

- Automated Policy Management: Policies are deployed and removed with the application, ensuring consistency and reducing manual tasks.
- Strict Configuration: The current configuration requires at least Layer 4 settings to be defined for policy deployment, promoting stricter security practices.
