# terraform-advanced-logic-demo

A demo Terraform configuration illustrating a few semi-advanced Terraform capabilities, namely the expression of moderately complex logic.

`terraform-advanced-logic-demo` is the reference example accompanying the [Advanced Terraform Logic](TODO) blog post.

## Try it out

The Terraform configuration assumes the existence of a `GITHUB_TOKEN` environment variable whose value is an authorized [GitHub personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token).

The Terraform configuration also assumes a local Grafana instance is running. To start a local Grafana:

```
make grafana
```

Run `terraform plan`:

```
make tf-plan
```
