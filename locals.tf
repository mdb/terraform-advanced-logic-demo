locals {
  owner = "vinyldns"

  # filter out archived repositories and empty repositories with no branches
  github_repositories = {
    for k, v in data.github_repository.all : k => v
    if !v.archived && length(data.github_repository_branches.all[v.full_name].branches) > 0
  }

  # collect a list of objects in the format of...
  # {
  #   repo      = repository-name
  #   folder    = github-owner_repository-name
  #   dashboard = github-owner_repository-name_microservice
  # }
  # ...where `microservice` is the directory name in which a Dockerfile lives.
  # For example, the following directory structure homes 'foo' and 'bar' container images:
  # repository-name/
  #   foo/Dockerfile
  #   bar/Dockerfile
  dynamic_dashboards = distinct(flatten([
    for repo_tree in data.github_tree.all : [
      for entry in repo_tree.entries : {
        repo      = repo_tree.repository
        folder    = "${local.owner}_${replace(repo_tree.repository, ".", "")}"
        dashboard = try("${local.owner}_${replace(repo_tree.repository, ".", "")}_${split("/", entry.path)[length(split("/", entry.path)) - 2]}", "${local.owner}_${replace(repo_tree.repository, ".", "")}")
      } if endswith(entry.path, "Dockerfile")
    ]
  ]))

  # static_folders is a list of static folder configurations, as specified by additional_dashboards.yaml
  # This enables supplementing local.grafana_folders with additional, statically defined folder details.
  static_dashboards = yamldecode(file("${path.module}/additional_dashboards.yaml"))

  # grafana_dashboards is the combination of the dynamic_dashboards and static_dashboards
  grafana_dashboards = concat(local.dynamic_dashboards, local.static_dashboards)

  # grafana_folders is a list of unique folder names
  grafana_folders = distinct([
    for dashboard in local.grafana_dashboards : dashboard.folder
  ])
}
