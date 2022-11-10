resource "grafana_folder" "all" {
  for_each = { for folder in local.grafana_folders : folder.folder_name => folder }

  title = each.value.folder_name
}

resource "grafana_dashboard" "all" {
  for_each = grafana_folder.all

  folder      = each.value.id
  config_json = jsonencode({
    title = each.value.title,
    uid   = replace(lower(each.value.title), "_", "-")
  })
}
