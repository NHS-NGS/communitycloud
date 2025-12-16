# somerset-ldp-infrastructure

## Terraform Scaffold

A framework for controlling multi-environment multi-component terraform-managed AWS infrastructure.

### Overview

Terraform scaffold consists of a terraform wrapper bash script, a bootstrap script and a set of directories providing the locations to store terraform code and variables.

| Thing	| Things about the Thing |
|-------|------------------------|
| bin/terraform.sh | The terraformscaffold script |
| bootstrap/ | The bootstrap terraform code used for creating the terraformscaffold S3 bucket |
| components/ |	The location for terraform "components". Terraform code intended to be run directly as a root module. |
| etc/ | The location for environment-specific terraform variables files:<br/>`env_{region}_{environment}.tfvars`<br/>`versions_{region}_{environment}.tfvars` |
| lib/ | Optional useful libraries, such as Jenkins pipeline groovy script |
| modules/ | The optional location for terraform modules called by components |
| plugin-cache/ | The default directory used for caching plugin downloads |
| src/ | The optional location for source files, e.g. source for lambda functions zipped up into artefacts inside components |

#### Variables Files: Environment & Versions

Scaffold provides a logical separation of several types of environment variable:
 * Global variables
 * Region-scoped global variables
 * Group variables
 * Static environment variables
 * Frequently-changing versions variables
 * Dynamic (S3 stored) variables
 * Secret (S3 stored, KMS encrypted variables - available but not recommended)

This seperation is purely logical, not functional. It makes no functional difference in which file a variable lives, or even whether a versions variables file exists; but it provides the capacity to seperate out mostly static variables that define the construction of the environment from variables that could change on each apply providing new AMI IDs, or dockerised application versions or database snapshot IDs when recreating development and testing databases.

## Usage

```bash
bin/terraform.sh \
  -a/--action              `action` \
  -b/--bucket-prefix       `bucket_prefix` \
  -c/--component           `component_name` \
  -e/--environment         `environment` \
  -g/--group               `group` (optional) \
  -i/--build-id            `build_id` (optional) \
  -l/--lockfile            `mode` (optional) \
  -p/--project             `project` \
  -r/--region              `region` \
  -d/--detailed-exitcode   (optional) \
  -j/--disable-output-json (optional) \
  -t/--lock-table          (optional) \
  -n/--no-color            (optional) \
  -w/--compact-warnings    (optional) \
  -- \
  <additional arguments to forward to the terraform binary call>
```

The example below shows a command that runs Terraform for the Development environment and the Account component:
```bash
bin/terraform.sh -t -r eu-west-2 -p somerset -e dev -c account -a plan/apply
```
## Git hooks

### Pre-push

In `.git/hooks/pre-push` add:
```
#!/bin/sh
set -e

BASE_PATH="$(realpath "${BASH_SOURCE[0]}/../../../")"
COMPONENTS_PATH="$BASE_PATH/components"
CHANGES_APPLIED=0

cd $BASE_PATH/components
if ! command -v terraform >/dev/null 2>&1
then
    echo "❌ Terraform is not installed."
    exit 1
fi
if ! command -v terraform-docs >/dev/null 2>&1
then
    echo "❌ terraform-docs is not installed."
    exit 1
fi
echo "🚀 Enforcing Terraform code formatting and updating components documentation ..."
fmt_files=$(terraform fmt --recursive)
[ -n "$fmt_files" ] && CHANGES_APPLIED=1

cd $BASE_PATH

for COMPONENT in $COMPONENTS_PATH/*/; do
  if [ -f "$COMPONENT/README.md" ]; then
    before=$(md5 "$COMPONENT/README.md" | awk -F'= ' '{print $2}')
    terraform-docs markdown table $COMPONENT --output-file README.md --output-mode inject --hide resources > /dev/null
    after=$(md5 "$COMPONENT/README.md" | awk -F'= ' '{print $2}')
    [ "$before" != "$after" ] && CHANGES_APPLIED=1
  else
    echo "⚠️ No README.md found for $COMPONENT."
  fi
done

[ "$CHANGES_APPLIED" = 1 ] && echo "✅ Terraform code formatting enforced and components documentation updated.\n📌 Please review the auto-applied changes, then commit and push again."
[ "$CHANGES_APPLIED" = 0 ] && echo "✅ All good."
echo

exit $CHANGES_APPLIED
```
