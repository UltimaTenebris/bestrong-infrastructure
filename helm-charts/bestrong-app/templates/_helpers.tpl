{{- define "bestrong.name" -}}
{{- default .Chart.Name .Values.appId | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "bestrong.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "bestrong.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "bestrong.labels" -}}
app.kubernetes.io/name: {{ .Values.appId | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | quote }}
{{- end -}}

{{- define "bestrong.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.appId | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end -}}
