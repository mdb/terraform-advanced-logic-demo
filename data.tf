data "github_repositories" "owner" {
  query = "org:${local.owner}"
}

data "github_repository" "all" {
  for_each = toset(data.github_repositories.owner.full_names)

  full_name = each.value
}

data "github_repository_branches" "all" {
  for_each = data.github_repository.all

  repository = each.value.name
}

data "github_branch" "default_branches" {
  for_each = local.github_repositories

  repository = each.value.name
  branch     = each.value.default_branch
}

data "github_tree" "all" {
  for_each = data.github_branch.default_branches

  recursive  = true
  repository = each.value.repository
  tree_sha   = each.value.sha
}
