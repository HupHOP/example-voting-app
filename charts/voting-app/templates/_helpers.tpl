{{/* Image reference for one of our own services: registry/voting-app-<name>:<tag> */}}
{{- define "voting-app.image" -}}
{{ .root.Values.image.registry }}/voting-app-{{ .name }}:{{ .tag | default .root.Values.image.tag }}
{{- end -}}
