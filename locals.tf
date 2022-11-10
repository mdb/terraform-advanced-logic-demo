locals {
  owner = "vinyldns"

  # filter out archived repositories and empty repositories with no branches
  github_repositories = {
    for k, v in data.github_repository.all : k => v
    if !v.archived && length(data.github_repository_branches.all[v.full_name].branches) > 0
  }

  # collect a list of objects in the format of...
  # {
  #   repo        = repository-name
  #   folder_name = mdb_repository-name_software-component-name
  # }
  # ...where `software-component-name` is the directory name in which a Dockerfile lives.
  # For example, the following directory structure homes 'foo' and 'bar' container images:
  # repository-name/
  #   foo/Dockerfile
  #   bar/Dockerfile
  dynamic_folders = distinct(flatten([
    for repo_tree in data.github_tree.all : [
      for entry in repo_tree.entries : {
        repo        = repo_tree.repository
        folder_name = try("${local.owner}_${replace(repo_tree.repository, ".", "")}_${split("/", entry.path)[length(split("/", entry.path)) - 2]}", "fallback")
      } if endswith(entry.path, "Dockerfile") && length(split("/", entry.path)) > 1
    ]
  ]))

  # static_folders is a list of static folder configurations.
  # This enables supplementing local.grafana_folders with additional, statically defined folder details.
  static_folders = [{
    repo        = "foo"
    folder_name = "${local.owner}_foo_bar"
  }]

  grafana_folders = concat(local.dynamic_folders, local.static_folders)
}
