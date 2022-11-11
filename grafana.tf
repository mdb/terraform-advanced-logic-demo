resource "grafana_folder" "all" {
  for_each = toset(local.grafana_folders)

  title = each.value
}

resource "grafana_dashboard" "all" {
  for_each = { for dashboard in local.grafana_dashboards : dashboard.dashboard => dashboard }

  folder      = grafana_folder.all[each.value.folder].id
  config_json = jsonencode({
    title = each.value.dashboard,
    uid   = replace(lower(each.value.dashboard), "_", "-")
  })
}
