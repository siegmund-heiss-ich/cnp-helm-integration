{{/* Ingress block */}}
{{- define "cilium.ingress" }}
{{- range .ingress }}
- {{- if not .toPorts }}
  {{- fail "Each 'ingress' rule must have 'toPorts' defined." }}
  {{- end }}

  {{- if .toPorts }}
    {{- range .toPorts }}
      {{- if .rules }}
        {{- if .rules.dns }}
          {{- fail "DNS rules are not allowed within the 'ingress' block." }}
        {{- end }}
      {{- end }}
    {{- end }}
  {{- end }}

  {{- if .fromEndpoints }}
  fromEndpoints:
    {{- range .fromEndpoints }}
    - matchLabels:
        {{- range $key, $value := .matchLabels }}
        {{ $key }}: {{ $value }}
        {{- end }}
    {{- end }}
  {{- end }}

  {{- if .fromCIDRSet }}
  fromCIDRSet:
    {{- range .fromCIDRSet }}
    - cidr: {{ .cidr }}
    {{- end }}
  {{- end }}

  toPorts:
    {{- include "cilium.toPorts" (dict "scope" .toPorts) | indent 6 }}
{{- end }}
{{- end }}

{{/* Egress block */}}
{{- define "cilium.egress" }}
{{- range .egress }}
- {{- if not .toPorts }}
  {{- fail "Each 'egress' rule must have 'toPorts' defined." }}
  {{- end }}

  {{- if .toEndpoints }}
  toEndpoints:
    {{- range .toEndpoints }}
    - matchLabels:
        {{- range $key, $value := .matchLabels }}
        {{ $key }}: {{ $value }}
        {{- end }}
    {{- end }}
  {{- end }}

  {{- if .toCIDRSet }}
  toCIDRSet:
    {{- range .toCIDRSet }}
    - cidr: {{ .cidr }}
    {{- end }}
  {{- end }}

  {{- if .toFQDNs }}
  toFQDNs:
    {{- range .toFQDNs }}
    - matchName: "{{ .matchName }}"
    {{- end }}
  {{- end }}

  toPorts:
    {{- include "cilium.toPorts" (dict "scope" .toPorts) | indent 6 }}
{{- end }}
{{- end }}

{{/* Generate toPorts */}}
{{- define "cilium.toPorts" }}
{{- if .scope }}
  {{- range .scope }}
  - ports:
      {{- range .ports }}
      - port: "{{ .port }}"
        protocol: {{ .protocol }}
      {{- end }}
    {{- if .rules }}
    rules:
      {{- if .rules.http }}
      http:
        {{- range .rules.http }}
        - method: "{{ .method }}"
          path: "{{ .path }}"
        {{- end }}
      {{- end }}
      {{- if .rules.kafka }}
      kafka:
        {{- range .rules.kafka }}
        - apiKey: "{{ .apiKey }}"
          apiVersion: "{{ .apiVersion }}"
          topic: "{{ .topic }}"
        {{- end }}
      {{- end }}
      {{- if .rules.dns }}
      dns:
        {{- range .rules.dns }}
        - matchPattern: "{{ .matchPattern }}"
        {{- end }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}
{{- end }}
