{{- define "bestrong.fullname" -}}
{{- printf "%s" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "bestrong.labels" -}}
app.kubernetes.io/managed-by: Helm
app.kubernetes.io/part-of: bestrong
app.kubernetes.io/name: {{ .Values.appId }}
app.kubernetes.io/color: {{ .Values.color }}
{{- end -}}

{{- define "bestrong.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.appId }}
app.kubernetes.io/color: {{ .Values.color }}
{{- end -}}
