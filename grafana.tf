resource "grafana_folder" "all" {
  for_each = { for folder in local.grafana_folders : folder.folder_name => folder }

  title = each.value.folder_name
}
